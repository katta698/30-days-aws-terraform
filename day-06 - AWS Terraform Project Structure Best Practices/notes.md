# Day 6 Notes: Terraform File Structure

Today I learned that Terraform does not care much about how many .tf files I create in a folder because it merges them into one configuration. The purpose of splitting files is mainly to make the code easier to read, maintain, and scale.

I organized the configuration into separate files such as backend.tf, provider.tf, variables.tf, locals.tf, vpc.tf, storage.tf, and outputs.tf. This made the project much cleaner compared to keeping everything inside one large main.tf.

A key lesson for me was that Terraform dependencies are based on resource references, not on file names. That means I can separate resources into meaningful files without worrying that Terraform will break just because one file comes before another alphabetically.

I also saw the value of grouping infrastructure by purpose. Networking resources belong together, storage resources belong together, and shared definitions like variables and locals should stay in their own files. This makes troubleshooting easier and helps other people understand the project faster.

Another useful practice is keeping naming conventions consistent. Clear file names make the project easier to navigate, especially as the infrastructure grows.

Overall, Day 6 helped me understand that good Terraform structure is less about syntax and more about clarity, maintainability, and long-term thinking.