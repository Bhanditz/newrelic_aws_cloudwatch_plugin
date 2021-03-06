module NewRelicAWS
  module Collectors
    class RDS < Base
      def instance_ids
        rds = AWS::RDS.new(
          :access_key_id => @aws_access_key,
          :secret_access_key => @aws_secret_key,
          :region => @aws_region
        )
        rds.instances.map { |instance| instance.id }
      end

      def metric_list
        {
          "BinLogDiskUsage"     => "Bytes",
          "CPUUtilization"      => "Percent",
          "DatabaseConnections" => "Count",
          "DiskQueueDepth"      => "Count",
          "FreeableMemory"      => "Bytes",
          "FreeStorageSpace"    => "Bytes",
          "ReplicaLag"          => "Seconds",
          "SwapUsage"           => "Bytes",
          "ReadIOPS"            => "Count/Second",
          "WriteIOPS"           => "Count/Second",
          "ReadLatency"         => "Seconds",
          "WriteLatency"        => "Seconds",
          "ReadThroughput"      => "Bytes/Second",
          "WriteThroughput"     => "Bytes/Second"
        }
      end

      def collect
        data_points = []
        instance_ids.each do |instance_id|
          metric_list.each do |metric_name, unit|
            data_point = get_data_point(
              :namespace   => "AWS/RDS",
              :metric_name => metric_name,
              :unit        => unit,
              :dimension   => {
                :name  => "DBInstanceIdentifier",
                :value => instance_id
              }
            )
            unless data_point.nil?
              data_points << data_point
            end
          end
        end
        data_points
      end
    end
  end
end
