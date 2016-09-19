module Rongcloud
  module Service
    class Wordfilter < Rongcloud::Service::Model
      # attr_accessor :user_id

      def add(word)
        post = {uri: Rongcloud::Service::API_URI[:WORDFILTER_ADD],
                params: optional_params({word: word})
        }
        res = Rongcloud::Service.req_post(post)
        res[:code]==200
      end

      def delete(word)
        post = {uri: Rongcloud::Service::API_URI[:WORDFILTER_DELETE],
                params: optional_params({word: word})
        }
        res = Rongcloud::Service.req_post(post)
        res[:code]==200
      end

      def list(word)
        post = {uri: Rongcloud::Service::API_URI[:WORDFILTER_LIST],
                params: optional_params({})
        }
        Rongcloud::Service.req_post(post)
      end

    end
  end
end
