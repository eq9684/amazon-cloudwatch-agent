#!/bin/bash
sudo yum install amazon-cloudwatch-agent -y > /amazon-cloudwatch-agent.log
sudo cat >/opt/aws/amazon-cloudwatch-agent/bin/config.json<<EOF
{
	"agent": {
		"metrics_collection_interval": 60,
		"run_as_user": "root"
	},
	"metrics": {
		"metrics_collected": {
			"disk": {
				"measurement": [
					"used_percent"
				],
				"metrics_collection_interval": 60,
				"resources": [
					"/"
				]
			},
			"mem": {
				"measurement": [
					"mem_used_percent"
				],
				"metrics_collection_interval": 60
			},
			"collectd": {}
		}
	}
}
EOF
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
sudo systemctl enable amazon-cloudwatch-agent

echo "0 4 * * 7 root yum update -y" >> /etc/crontab
echo "0 6 * * 7 root shutdown -r now" >> /etc/crontab


