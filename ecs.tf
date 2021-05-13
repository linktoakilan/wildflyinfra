resource "aws_ecs_cluster" "wildfly_cluster" {
  name               = "wildfly_cluster"
  capacity_providers = ["FARGATE"]
}

# resource "aws_ecs_cluster" "wildfly_cluster2" {
#   name = "wildfly_cluster2"
#   capacity_providers = [ "FARGATE" ]
# }

resource "aws_ecr_repository" "wildfly_ecr" {
  name = "wildfly_ecr"

}

resource "aws_service_discovery_private_dns_namespace" "wildfly_privatedns" {
  name = "wildfly.local"

  vpc = aws_vpc.example.id
}


resource "aws_service_discovery_service" "wildfly_servicediscovery" {
  name = "cluster"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.wildfly_privatedns.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}