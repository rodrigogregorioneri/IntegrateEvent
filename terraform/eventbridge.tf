data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_event_bus" "event_bus_neri" {
  name = "event_bus_neri"
}


resource "aws_cloudwatch_event_rule" "event_rule_neri" {
  name = "event_rule_neri"  
  event_bus_name = aws_cloudwatch_event_bus.event_bus_neri.name  
  event_pattern = <<PATTERN
{
  "source": ["neri"]
}
PATTERN
}



resource "aws_cloudwatch_event_target" "SFNTarget" {
  rule     = aws_cloudwatch_event_rule.event_rule_neri.name
  event_bus_name = aws_cloudwatch_event_bus.event_bus_neri.name  
  arn      = aws_sfn_state_machine.sfn_state_machine.arn
  role_arn = aws_iam_role.EventBridgeRole.arn
}


resource "aws_iam_role" "EventBridgeRole" {
  assume_role_policy = <<POLICY1
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "events.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }
  ]
}
POLICY1
}

resource "aws_iam_role_policy_attachment" "EventBridgePolicyAttachment" {
  role       = aws_iam_role.EventBridgeRole.name
  policy_arn = aws_iam_policy.EventBridgePolicy.arn
}


resource "aws_iam_policy" "EventBridgePolicy" {
  policy = <<POLICY3
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : [
        "states:StartExecution"
      ],
      "Resource" : "${aws_sfn_state_machine.sfn_state_machine.arn}"
    }
  ]
}
POLICY3
}
