resource "aws_route53_zone" "raymund" {
  name = "raymund.cloud"
}

resource "aws_route53_record" "root_a_record" {
  zone_id = aws_route53_zone.raymund.zone_id
  name    = aws_route53_zone.raymund.name
  type    = "A"

  alias {
    name                   = "d1pgrriw4n0rti.cloudfront.net" #TODO: get data source
    zone_id                = "Z2FDTNDATAQYW2"                #TODO: make this dynamic using data {} S3 hosted_zone_id
    evaluate_target_health = false
  }
}

# Record created from R53
resource "aws_route53_record" "acm_validation_1" {
  zone_id = aws_route53_zone.raymund.zone_id
  name    = "_50a1ac40af32add0ea4adc3f13f03f8d.www.raymund.cloud"
  type    = "CNAME"
  ttl     = 300
  records = ["_60df12cdd42f094208581a5b64aedd06.zfyfvmchrl.acm-validations.aws."]
}

# resource "aws_route53_record" "www_cname" {
#   zone_id = aws_route53_zone.raymund.zone_id
#   name    = "raymund.cloud"
#   type    = "CNAME"
#   ttl     = 300
#   records = ["d1pgrriw4n0rti.cloudfront.net"]
# }