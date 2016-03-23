module Chat
  class ConversationHeader < ActiveRecord::Base
    belongs_to "#{Chat.user_1_class.downcase}".to_sym unless Chat.only_one_model
    belongs_to "#{Chat.user_2_class.downcase}".to_sym unless Chat.only_one_model
    belongs_to "#{Chat.user_1_class.downcase}_1".to_sym, class_name: Chat.user_1_class if Chat.only_one_model
    belongs_to "#{Chat.user_1_class.downcase}_2".to_sym, class_name: Chat.user_1_class if Chat.only_one_model
    belongs_to :conversation, class_name: "Chat::Conversation"

    before_create :check_conversation
    after_create :create_inverse, if: :has_one_model?

    private

    def has_one_model?
      puts '*'*90
      puts Chat.only_one_model
      puts '*'*90
      Chat.only_one_model
    end

    def check_conversation
      if self.conversation.nil?
        self.conversation = Conversation.create
      end
    end

    def create_inverse
      ConversationHeader.find_or_create_by(
        "#{Chat.klass_1}_id": "#{self.send(Chat.klass_2).id}",
        "#{Chat.klass_2}_id": "#{self.send(Chat.klass_1).id}",
        conversation: conversation
      )
    end
  end
end
