# bootc-simple-demo

## config.toml

Currently the config.toml will create user rory. 

## Use GitHub Registry:

Create a Personal Access Token (Classic) with permission write:packages

Login in ghcr.io:

   ```
export NAMESPACE=roryschellekens
export GITHUB_USER=$NAMESPACE
export CR_PAT=xxx_XXXxxxXXxxx
echo $CR_PAT | podman login ghcr.io -u $GITHUB_USER --password-stdin
   ```


Build image:
   ```
podman build -t ghcr.io/$NAMESPACE/bootc-simple-demo:latest .

   ```
Push Image:
   ```
podman push ghcr.io/$NAMESPACE/bootc-simple-demo:latest

   ```

Build anaconda iso (for macosx apple silicon):
   ```
./build-vmdk-arm64.sh
   ```


## After installation of ISO:
Login on ghcr.io on the fedora VM
   ```
sudo -i
export CR_PAT=xxx_XXXxxxXXxxx
echo $CR_PAT | podman login ghcr.io -u $GITHUB_USER --password-stdin --authfile /etc/ostree/auth.json
   ```

or
   ```
sudo -i
export CR_PAT=xxx_XXXxxxXXxxx
echo $CR_PAT | podman login ghcr.io -u $GITHUB_USER --password-stdin
cp /run/containers/0/auth.json /etc/ostree/
   ```

Upgrade to latest image:
   ```
bootc upgrade --apply
   ```

Rollback to previous image:
   ```
bootc rollback --apply
   ```

## References:

 * https://access.redhat.com/solutions/7086221
 * https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry
 * https://github.com/osbuild/bootc-image-builder
