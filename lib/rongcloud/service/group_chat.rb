module Rongcloud
  module Service
    class GroupChat < Rongcloud::Service::Model
      attr_accessor :user_id
      attr_accessor :group_id
      attr_accessor :group_name

      def create
        post = {uri: Rongcloud::Service::API_URI[:GROUP_CREATE],
                params: optional_params({userId: self.user_id,
                                         groupId: self.group_id,
                                         group_name: self.group_name})}
        res = Rongcloud::Service.req_post(post)
        res[:code]==200
      end

      def join
        post = {uri: Rongcloud::Service::API_URI[:GROUP_JOIN],
        params: optional_params({userId: self.user_id,
                                 groupId: self.group_id,
                                 groupName: self.group_name})}
        res = Rongcloud::Service.req_post(post)
        res[:code]==200
      end

      def quit
        post = {uri: Rongcloud::Service::API_URI[:GROUP_QUIT],
                params: optional_params({userId: self.user_id,
                                         groupId: self.group_id})}
        res = Rongcloud::Service.req_post(post)
        res[:code]==200
      end

      def dismiss
        post = {uri: Rongcloud::Service::API_URI[:GROUP_DISMISS],
                params: optional_params({userId: self.user_id,
                                         groupId: self.group_id})}
        res = Rongcloud::Service.req_post(post)
        res[:code]==200
      end

      def user_query
        post = {uri: Rongcloud::Service::API_URI[:GROUP_USER_QUERY],
                params: optional_params({groupId: self.group_id})}
        Rongcloud::Service.req_post(post)        
      end

      # 禁言时长，以分钟为单位，最大值为43200分钟。
      def gag_add(minute)
        post = {uri: Rongcloud::Service::API_URI[:GROUP_USER_GAG_ADD],
                params: optional_params({userId: self.user_id,
                                         groupId: self.group_id,
                                         minute: minute})}
        res = Rongcloud::Service.req_post(post)
        res[:code]==200
      end

      def gag_rollback
        post = {uri: Rongcloud::Service::API_URI[:GROUP_USER_GAG_ROLLBACK],
                params: optional_params({userId: self.user_id,
                                         groupId: self.group_id})}
        res = Rongcloud::Service.req_post(post)
        res[:code]==200
      end

      def gag_list
        post = {uri: Rongcloud::Service::API_URI[:GROUP_USER_GAG_LIST],
                params: optional_params({groupId: self.group_id})}
        Rongcloud::Service.req_post(post)
      end

    end
  end
end