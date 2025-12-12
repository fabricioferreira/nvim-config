-- Detect .tf and .tfvars files as terraform filetype
vim.filetype.add({
  extension = {
    tf = "terraform",
    tfvars = "terraform-vars",
  },
  filename = {
    [".terraformrc"] = "hcl",
    ["terraform.rc"] = "hcl",
  },
})
