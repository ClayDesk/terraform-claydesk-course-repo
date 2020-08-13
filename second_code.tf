# Configure or specify the providers

provider "aws" {
    region = "us-east-1"
    profile = "claydesk-terraform"
}

provider "github" {
  token        = "91a81602a6dcaf6e6d43352b455c9301376d24c3"
  organization = "ClayDesk"
}

# This resource allows you to create a GitHub repository.

resource "github_repository" "terraform-claydesk-course-repo" {
  name        = "terraform-claydesk-course-repo"
  description = "My awesome terraform repo"
  has_projects = true
  private = true
}

# This resource allows you to create and manage projects for GitHub repository.

resource "github_repository_project" "terraform_claydesk_cicd_project" {
  name       = "A Repository Project for Terraform ClayDesk CICD Pipeline"
  repository = "${github_repository.terraform-claydesk-course-repo.name}"
  body       = "This is a repository project for cicd pipeline."
}

/* 
Add a collaborator to a repository.
The permission of the outside collaborator for the repository.
Must be one of pull, push, maintain, triage or admin. Defaults to push.
*/

resource "github_repository_collaborator" "a_repo_collaborator" {
  repository = "terraform-claydesk-course-repo"
  username   = "myragul"
  permission = "admin"
}
/* Add a team to the organization. Privacy is closed.
If not specified, then defaults to secret
*/
resource "github_team" "team_claydesk" {
  name        = "team_claydesk"
  description = "team_claydesk"
  privacy     = "closed"
}
resource "github_team_repository" "terraform-claydesk-course-repo" {
  team_id    = "${github_team.team_claydesk.id}"
  repository = "${github_repository.terraform-claydesk-course-repo.name}"
  permission = "pull"
}

/* The role of the user within the team.
Must be one of member or maintainer. Defaults to member.
*/

resource "github_team_membership" "team_claydesk_membership" {
  team_id  = "${github_team.team_claydesk.id}"
  username = "myragul"
  role     = "maintainer"
}