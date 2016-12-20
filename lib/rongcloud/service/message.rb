module Rongcloud
  module Service
    class Message < Rongcloud::Service::Model
      attr_accessor :from_user_id
      attr_accessor :to_user_id
      attr_accessor :to_group_id
      # attr_accessor :object_name #消息类型
      attr_accessor :push_data
      attr_accessor :push_content
      attr_accessor :is_include_sender
      attr_accessor :rc_msg

      def initialize(attributes = {})
        super(attributes)
        @is_include_sender = 1 if @is_include_sender.nil?
      end
      
      # 群组消息
      def group_publish
        post = {uri: Rongcloud::Service::API_URI[:MSG_GROUP_PUBLISH],
                params: optional_params({fromUserId: self.from_user_id, toGroupId: self.to_group_id,
                                         objectName: self.rc_msg.class::MESSAGE_TYPE, content: self.rc_msg.json_content,
                                         pushData: self.push_data, isIncludeSender: self.is_include_sender})
        }
        Rongcloud::Service.req_post(post)
      end

      #发送单聊消息
      def private_publish
        post = {uri: Rongcloud::Service::API_URI[:MSG_PRV_PUBLISH],
                params: optional_params({fromUserId: self.from_user_id, toUserId: self.to_user_id,
                                         objectName: self.rc_msg.class::MESSAGE_TYPE,
                                         pushData: self.push_data,
                                         pushContent: self.push_content,
                                         content: self.rc_msg.json_content})
        }
        Rongcloud::Service.req_post(post)
      end

      #发送系统消息
      def system_public
        post = {uri: Rongcloud::Service::API_URI[:MSG_SYSTEM_PUBLISH],
                params: optional_params({fromUserId: self.from_user_id, toUserId: self.to_user_id,
                                         objectName: self.rc_msg.class::MESSAGE_TYPE,
                                         pushData: self.push_data,
                                         pushContent: self.push_content,
                                         content: self.rc_msg.json_content})
        }
        Rongcloud::Service.req_post(post)
      end

      #消息历史记录
      def history(date_str)
        post = {uri: Rongcloud::Service::API_URI[:MSG_HISTORY],
                params: optional_params({date: date_str})
        }
        Rongcloud::Service.req_post(post)
      end
    end

    # 不同类型的消息
    class RCMsg < Rongcloud::Service::Model
      attr_accessor :content
      attr_accessor :extra
      attr_accessor :is_include_sender

      def initialize(attributes = {})
        if attributes.present?
          attributes.each { |k, v| send("#{k}=", v) if respond_to?("#{k}=") }
        end
        @is_include_sender = 1 if @is_include_sender.nil?
      end

      def necessary_attrs
      end

      def json_content
        necessary_attrs.to_json
      end
    end

    class RCCmdNtf < Rongcloud::Service::RCMsg
      MESSAGE_TYPE = 'RC:CmdNtf'.freeze

      attr_accessor :name, :data

      def necessary_attrs
        {name: self.name, data: self.data}
      end
    end

    class RCCmdMsg < Rongcloud::Service::RCMsg
      MESSAGE_TYPE = 'RC:CmdMsg'.freeze

      attr_accessor :name, :data

      def necessary_attrs
        {name: self.name, data: self.data}
      end
    end

    class RCInfoNtf < Rongcloud::Service::RCMsg
      MESSAGE_TYPE = 'RC:InfoNtf'.freeze

      attr_accessor :message

      def necessary_attrs
        {message: self.message, extra: self.extra}
      end
    end

    class RCTxtMsg< Rongcloud::Service::RCMsg
      MESSAGE_TYPE = 'RC:TxtMsg'.freeze

      def necessary_attrs
        {content: self.content, extra: self.extra}
      end
    end

    class RCImgMsg< Rongcloud::Service::RCMsg
      MESSAGE_TYPE = 'RC:ImgMsg'.freeze

      attr_accessor :image_uri

      def necessary_attrs
        {content: self.content, imageUri: self.image_uri}
      end
    end

    class RCVcMsg< Rongcloud::Service::RCMsg
      MESSAGE_TYPE = 'RC:VcMsg'.freeze

      attr_accessor :duration

      def necessary_attrs
        {content: self.content, duration: self.duration, extra: self.extra}
      end
    end

    class RCImgTextMsg< Rongcloud::Service::RCMsg
      MESSAGE_TYPE = 'RC:ImgTextMsg'.freeze

      attr_accessor :title
      attr_accessor :image_uri
      attr_accessor :url

      def necessary_attrs
        {title: self.title, content: self.content, imageUri: self.image_uri, url: self.url, extra: self.extra}
      end
    end

    #自定义模板消息
    class CUTemplateTextMsg < Rongcloud::Service::RCMsg
      attr_accessor :title
      attr_accessor :items
      attr_accessor :url

      def necessary_attrs
        {title: self.title, content: self.content, items: self.items, url: self.url}
      end
    end

    class RCLBSMsg< Rongcloud::Service::RCMsg
      MESSAGE_TYPE = 'RC:LBSMsg'.freeze

      attr_accessor :latitude
      attr_accessor :longitude
      attr_accessor :poi

      def necessary_attrs
        {content: self.content, latitude: self.latitude, longitude: self.longitude, poi: self.poi, extra: self.extra}
      end
    end

    class RCContactNtf< Rongcloud::Service::RCMsg
      MESSAGE_TYPE = 'RC:ContactNtf'.freeze

      attr_accessor :operation
      attr_accessor :source_user_id
      attr_accessor :target_user_id
      attr_accessor :message

      def necessary_attrs
        {operation: self.operation, sourceUserId: self.source_user_id, targetUserId: self.target_user_id, message: self.message, extra: self.extra}
      end
    end
  end
end