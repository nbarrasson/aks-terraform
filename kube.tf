# Put your kubernetes resources here (namespaces, pods, role, rolebinding, etc)

# Creating a namespace
module "namespace1" {
  source         = "./modules/namespace"
  namespace_name = var.namespace_name1
}