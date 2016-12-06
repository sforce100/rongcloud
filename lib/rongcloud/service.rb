module Rongcloud
  module Service

    API_URI = {
        USER_GET_TOKEN: '/user/getToken.json',
        USER_REFRESH: '/user/refresh.json',
        USER_BLOCK: '/user/block.json',
        USER_UNBLOCK: '/user/unblock.json',
        USER_BLOCK_QUERY: '/user/block/query.json',
        MSG_PRV_PUBLISH: '/message/private/publish.json',
        MSG_SYSTEM_PUBLISH: '/message/system/publish.json',
        MSG_HISTORY: '/message/history.json',
        MSG_GROUP_PUBLISH: '/message/group/publish.json',
        GROUP_SYNC: '/group/sync.json',
        GROUP_CREATE: '/group/create.json',
        GROUP_JOIN: '/group/join.json',
        GROUP_QUIT: '/group/quit.json',
        GROUP_DISMISS: '/group/dismiss.json',
        GROUP_USER_QUERY: '/group/user/query.json',
        GROUP_USER_GAG_ADD: '/group/user/gag/add.json',
        GROUP_USER_GAG_ROLLBACK: '/group/user/gag/rollback.json',
        GROUP_USER_GAG_LIST: '/group/user/gag/list.json',
        WORDFILTER_ADD: '/wordfilter/add.json',
        WORDFILTER_DELETE: '/wordfilter/delete.json',
        WORDFILTER_LIST: '/wordfilter/list.json'
    }

    def self.req_get(config)

      config = default_request_config(config)

      conn = Faraday.new(:url => config[:host])
      response = conn.get do |req|
        req.url config[:uri]
        config[:headers].each { |key, value| req.headers[key.to_s] = value.to_s }
        config[:params] && config[:params].each { |key, value| req.params[key.to_s] = value.to_s }
      end

      response_body = response.body
      Rails.logger.info("get response #{response_body}")
      res_data(response_body)
    end

    def self.req_post(config, post_format='urlencode')

      config = default_request_config(config)

      conn = Faraday.new(:url => config[:host])
      response = conn.post do |req|
        req.url config[:uri]
        config[:headers].each { |key, value| req.headers[key.to_s] = value.to_s }
        if post_format.to_s == 'urlencode'
          req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
          req.body = config[:params].collect { |key, value| "#{key}=#{value.to_s.urlencode}" }.join('&')
        elsif post_format.to_s == 'json'
          req.headers['Content-Type'] = 'application/json'
          req.body = config[:params].to_json
        end
        Rails.logger.info("post #{req.body}")
      end

      response_body = response.body
      Rails.logger.info("post response #{response_body}")
      res_data(response_body)
    end

    def self.res_data(response_body)
      sym_keyed_hash(JSON.parse(response_body))
    end

    #返回key为sym的hash
    def self.sym_keyed_hash(hash)
      hash.inject({}) { |memo, (key, v)| memo[key.to_sym]=v; memo }
    end

    def self.default_request_config(config)
      config[:host] ||= Rongcloud.api_host
      config[:uri] ||= nil
      config[:params] ||= {}
      config[:headers] ||= Rongcloud::Sign.gen_headers
      config
    end

    # 所有数据类的父类
    class Model
      def initialize(attributes = {})
        if attributes.present?
          attributes.each { |k, v| send("#{k}=", v) if respond_to?("#{k}=") }
        end
      end
      
      private
      #返回可选参数（为空的参数不返回）
      def optional_params(params)
        params.select { |key, v| v }
      end
    end
  end
end