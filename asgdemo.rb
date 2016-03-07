require 'aws-sdk'
require 'benchmark'
require 'sinatra'

cloudwatch = Aws::CloudWatch::Client.new(region: 'us-east-1')

get '/' do
    calc_time = Benchmark.realtime do
      for i in 0..50000
        puts Math.sqrt(Math::PI)
      end
    end

    # Convert to milliseconds.
    calc_time = calc_time * 1000

    # Send data to AWS Cloudwatch
    resp = cloudwatch.put_metric_data({
      namespace: "BR/AsgDemo",
      metric_data: [ 
        {
          metric_name: "calc_time",
          timestamp: Time.now,
          value: calc_time,
          unit: "Milliseconds",
        },
      ],
    })

    return "Calculated the squareroot of Pi 100 times in #{calc_time}ms!"
end
