%{
  title: "Deploying to Fly.io",
  author: "Bozidar Mitrovic",
  tags: ~w(deployment fly.io phoenix ai-written),
  description: "Quick deployment to production"
}
---

Deploying this blog was surprisingly simple:

1. Go to https://fly.io
2. Create account and deploy app
3. Connect to GitHub repo
4. Done

The deployment process with Fly.io was seamless. Within minutes of connecting my GitHub repository, I had a live Phoenix application running at https://vibelog.fly.dev/. 

Fly.io automatically detected the Phoenix app, configured the build process, and provisioned the necessary resources. The free tier provides enough resources for a simple blog like this, making it perfect for side projects and personal sites.

## Continuous Deployment

To automatically deploy changes when pushing to GitHub, I enabled auto-deploy in the Fly.io Launch UI:

1. Navigate to App > Deployments 
2. Click "settings"
3. Enable auto-deploying 
4. Specify which branch to deploy from (main)

Now every git push triggers an automatic deployment - no manual `flyctl deploy` needed!

Live at https://vibelog.fly.dev