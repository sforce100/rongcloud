module Rongcloud
  module Service
    class User < Rongcloud::Service::Model
      attr_accessor :user_id
      attr_accessor :name
      attr_accessor :portrait_uri
      attr_accessor :token

      #获取用户的token
      def get_token
        post = {uri: Rongcloud::Service::API_URI[:USER_GET_TOKEN],
                params: optional_params({userId: self.user_id, name: self.name, portraitUri: self.portrait_uri})
        }
        res = Rongcloud::Service.req_post(post)
        self.token = res[:token]
        res[:token]
      end

      #刷新用户信息
      def refresh
        post = {uri: Rongcloud::Service::API_URI[:USER_REFRESH],
                params: optional_params({userId: self.user_id, name: self.name, portraitUri: self.portrait_uri})
        }
        res = Rongcloud::Service.req_post(post)
        res[:code]==200
      end

      def block(minute)
        post = {uri: Rongcloud::Service::API_URI[:USER_BLOCK],
                params: optional_params({userId: self.user_id, minute: minute})
        }
        res = Rongcloud::Service.req_post(post)
        res[:code]==200
      end

      def unblock
        post = {uri: Rongcloud::Service::API_URI[:USER_UNBLOCK],
                params: optional_params({userId: self.user_id})
        }
        res = Rongcloud::Service.req_post(post)
        res[:code]==200
      end

      def block_query
        post = {uri: Rongcloud::Service::API_URI[:USER_BLOCK_QUERY],
                params: optional_params({})
        }
        Rongcloud::Service.req_post(post)
      end

    end
  end
end