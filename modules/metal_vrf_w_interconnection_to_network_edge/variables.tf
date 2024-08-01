variable "auth_token" {
    type = string
}
variable "project_id" {
    type = string
}
variable "metro" {
    type = string
}
variable "primary_ne_device_uuid" {
    type = string
}
variable "secondary_ne_device_uuid" {
    type = string
}
variable "primary_ne_device_port" {
    type = number
}
variable "secondary_ne_device_port" {
    type = number
}
variable "interconnection_speed" {
    type = number
}
variable "interconnection_notification_email" {
    type = string
}
variable "metal_asn" {
    type = string
}
variable "ip_ranges" {
    type = set(string)
}
variable "peer_asn" {
    type = string
}
variable "peer_subnet" {
    type = string
}
variable "peer_subnet-pri" {
    type = string
}
variable "cust_bgp_peer-pri" {
    type = string
}
variable "metal_bgp_peer-pri" {
    type = string
}
variable "shared_md5-pri" {
    type = string
}
variable "peer_subnet-sec" {
    type = string
}
variable "cust_bgp_peer-sec" {
    type = string
}
variable "metal_bgp_peer-sec" {
    type = string
}
variable "shared_md5-sec" {
    type = string
}