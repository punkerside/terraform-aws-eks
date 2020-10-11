output "values" {
  description = "Values of EKS"
  value       = module.eks.values.name
}