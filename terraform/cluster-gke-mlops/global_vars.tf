
variable "project_mlops" {
  type        = string
  default     = "mlops-312413"
  description = "Identificador del proyecto mlops"
}

variable "region" {
  type        = string
  default     = "us-east1"
  description = "Región por defecto para asignar regiones y zonas"
}


variable "name_cluster_mlops" {
  type        = string
  default     = "cluster-mlops"
  description = "Nombre del cluster GKE"
}

variable "name_node_pool_mlops" {
  type        = string
  default     = "node-pool-mlops"
  description = "Nombre del node pool GKE"
}


variable "staging_bucket_mlops" {
  type        = string
  default     = "bucket-mlops"
  description = "Nombre del bucket"
}

variable "machine_type" {
  type        = string
  default     = "n1-standard-2"
  description = "Tipo de maquinas"
}

variable "disk_type" {
  type        = string
  default     = "pd-ssd"
  description = "Tipo de maquinas"
}

variable "image_type" {
  type        = string
  default     = "COS"
  description = "Versión de imagen de los nodos  gke"
}

variable "node_metadata" {
  type        = string
  default     = "GCE_METADATA"
  description = ""
}