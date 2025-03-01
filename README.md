# fara_chat
### Based on flutter_chat v1:
    - https://github.com/faradzhalelov/flutter_chat

Simple flutter chat app (Supabase && drift)

## Мессенджер на Flutter

### Экраны:
    - Список диалогов:
        1. Отображение списка чатов с аватарками, именами собеседников и последними сообщениями.
        2. Сортировка чатов по времени последнего сообщения.
        3. Возможность удаления диалога свайпом.
        4. Реактивное обновление списка при изменении данных.
    - Экран чата с сообщениями:
        1. Отображение истории сообщений с разделением по дням.
        2. Ввод нового сообщения с возможностью отправки.
        3. Реактивное обновление чата при отправке нового сообщения.
        4. Автоматическая прокрутка вниз при добавлении новых сообщений.
        5. Возможность выбрать фотографию из галереи, при нажатии на кнопку с иконкой скрепки. Фотография должна отправляться в чат, а файл самой фотографии должен сохраняться локально на устройстве, чтобы иметь возможность просмотреть фото после перезапуска приложения. 

### Требования:
    - Локальное хранилище:
        1. Список чатов и сообщений должен сохраняться в локальной базе данных.
        2. При запуске приложения данные загружаются из хранилища.
    - Управление состоянием:
        1. Использование Provider, Riverpod или Bloc на выбор кандидата.

### Figma:
    - https://www.figma.com/design/sZlbHjGr8gXuEnsXnbDunV/

### Supabase:
    - test users: 
        - email= tester@mail.com password= Password
        - email= tester2@mail.com password= Password

    - db:

            -- Enable UUID extension
        CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

        -- Create users table (simplified)
        CREATE TABLE users (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        email TEXT UNIQUE NOT NULL,
        username TEXT NOT NULL,
        avatar_url TEXT,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        is_online BOOLEAN DEFAULT FALSE
        );

        -- Create chats table (with auto-deletion when user is removed)
        CREATE TABLE chats (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        name TEXT, -- Optional name for group chats
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        
        -- Array of user IDs who are part of this chat
        user_ids UUID[] NOT NULL,
        
        -- Last message information (all nullable)
        last_message_text TEXT DEFAULT NULL,
        last_message_user_id UUID DEFAULT NULL,
        last_message_type TEXT DEFAULT NULL,
        last_message_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
        
        -- Constraint to ensure at least one user in the chat
        CONSTRAINT at_least_one_user CHECK (array_length(user_ids, 1) > 0)
        );

        -- Create messages table
        CREATE TABLE messages (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        chat_id UUID REFERENCES chats(id) ON DELETE CASCADE, -- Will delete messages when chat is deleted
        user_id UUID DEFAULT NULL, -- No foreign key to enable removal without complex triggers
        content TEXT,
        type TEXT DEFAULT 'text' CHECK (type IN ('text', 'image', 'file', 'video', 'audio')),
        file_url TEXT,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );

        -- Function to update chat's last message info
        CREATE OR REPLACE FUNCTION update_chat_last_message()
        RETURNS TRIGGER AS $$
        BEGIN
        UPDATE chats 
        SET 
            last_message_text = NEW.content,
            last_message_user_id = NEW.user_id,
            last_message_type = NEW.type,
            last_message_at = NEW.created_at,
            updated_at = NEW.created_at
        WHERE id = NEW.chat_id;
        RETURN NEW;
        END;
        $$ LANGUAGE plpgsql;

        -- Trigger to update chat last message when new message is added
        CREATE TRIGGER update_chat_last_message
        AFTER INSERT ON messages
        FOR EACH ROW
        EXECUTE FUNCTION update_chat_last_message();

        -- Function to delete chats when a user is deleted
        CREATE OR REPLACE FUNCTION delete_user_chats() 
        RETURNS TRIGGER AS $$
        BEGIN
        -- Delete all chats where the deleted user is a member
        DELETE FROM chats 
        WHERE OLD.id = ANY(user_ids);
        
        RETURN OLD;
        END;
        $$ LANGUAGE plpgsql;

        -- Trigger to delete chats when a user is deleted
        CREATE TRIGGER on_user_delete
        BEFORE DELETE ON users
        FOR EACH ROW
        EXECUTE FUNCTION delete_user_chats();

        -- Function to check if a user is a member of a chat
        CREATE OR REPLACE FUNCTION is_chat_member(chat_id UUID, user_id UUID) 
        RETURNS BOOLEAN AS $$
        BEGIN
        RETURN EXISTS (
            SELECT 1 FROM chats 
            WHERE id = chat_id AND user_id = ANY(user_ids)
        );
        END;
        $$ LANGUAGE plpgsql;

        -- Create an index on the user_ids array for better performance
        CREATE INDEX idx_chats_user_ids ON chats USING GIN (user_ids);

        -- View to get all chats for a specific user with last message info
        CREATE VIEW user_chats AS
        SELECT 
        c.*,
        u.id as user_id,
        u.username,
        CASE 
            WHEN c.last_message_user_id = u.id THEN TRUE 
            ELSE FALSE 
        END as is_last_message_mine
        FROM chats c, users u
        WHERE u.id = ANY(c.user_ids)
        ORDER BY c.last_message_at DESC NULLS LAST, c.created_at DESC;


### How it works:
    - auth with firebase(login, register), add user to users table
    - chat list. sync chats from supabase, add to local db, listen to updates
    - chat messages. sync messages from supabase, add to local db, listen to messages
    - profile: user profile.


### Build Release apk
    - flutter build apk --release --build-name=0.0.1 --build-number=20250301

### Apk Download
    Github:
    - https://github.com/faradzhalelov/fara_flutter_chat/releases/tag/0.0.1
    Google Drive:
    - https://drive.google.com/file/d/1T-BIZFkN4zAnYGUuAf_GyzrEhuBgzhYA/view?usp=sharing

### Video Preview

    Google Drive:
    - https://drive.google.com/file/d/1yDCIzH537d1Uy1vN_3UbCNGNlZhYL5Kl/view?usp=sharing

<video width="640" height="360" controls>
  <source src="https://raw.githubusercontent.com/faradzhalelov/fara_flutter_chat/main/Screen%20Recording%202025-03-01%20at%2016.57.02.mp4" type="video/mp4">
</video>