# frozen_string_literal: true

module StraightA
  module Config
    class PaperclipDefaults
      attr_reader :use_local_storage

      def initialize
        @use_local_storage = (Rails.env.development? || Rails.env.test?)
      end

      def category_defaults
        base_defaults.merge(category_specific)
      end

      private

      def category_specific
        {
          styles: {
            thumbnail: '100x100#',
            normal: '250x250>',
            large: '400x400>'
          },
          default_style: 'normal'
        }
      end

      def base_defaults
        use_local_storage ? local_defaults : s3_defaults
      end

      def local_defaults
        {
          storage: :fog,
          fog_credentials: {
            provider: 'Local',
            local_root: "#{Rails.root}/public"
          },
          fog_directory: '',
          fog_host: 'localhost'
        }
      end

      def s3_defaults
        {
          storage: :s3,
          s3_credentials: {
            access_key_id: ENV.fetch('S3_ACCESS_KEY_ID'),
            secret_access_key: ENV.fetch('S3_SECRET_ACCESS_KEY'),
            bucket: ENV.fetch('PAPERCLIP_S3_BUCKET')
          },
          s3_protocol: :https,
          s3_region: ENV.fetch('PAPERCLIP_S3_BUCKET_REGION'),
          s3_headers: { 'Cache-Control' => 'max-age=31557600' }
        }
      end
    end
  end
end
