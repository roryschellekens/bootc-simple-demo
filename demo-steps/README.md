# Stappen voor demo (Dutch)

## Voorbereidingen

Software installaties op Macos 26 (Apple Silicon)
* Podman-Desktop
* Virtualbox

Zorg ervoor dat podman in rootful modes draait.
```
podman machine stop
podman machine set --rootful
podman machine start
```
Clone deze repo:
```
git clone   
```


Bouw de container lokaal:
```
export NAMESPACE=rorybricks
podman build -t ghcr.io/$NAMESPACE/bootc-simple-demo:latest .
```

Bouw de VMDK image van de bootable container:
```
./build-vmdk-arm64.sh
```

Start de VM in Virtualbox:
```
./run-vm.sh
```



# Demo

Voeg het software pakket cowsay toe aan de container image:

```
RUN <<EORUN
# Set pipefail to display failures within the heredoc and avoid false-positive successful builds.
set -xeuo pipefail
# Install necessary packages, run scripts, etc.
dnf install -y cowsay
# Remove leftover build artifacts from installing packages in the final built image.
dnf clean all
rm /var/{log,cache,lib}/* -rf
EORUN
```
Bouw de container en push naar GHCR:
```
podman build -t ghcr.io/$NAMESPACE/bootc-simple-demo:latest .
podman push ghcr.io/$NAMESPACE/bootc-simple-demo:latest
```

Login on de VM en update de bootable container image:
```
ssh -p 2222 core@localhost
sudo -i

export CR_PAT=xxx_XXXxxxXXxxx
echo $CR_PAT | podman login ghcr.io -u $GITHUB_USER --password-stdin --authfile /etc/ostree/auth.json
bootc update ghcr.io/$NAMESPACE/bootc-simple-demo:latest --apply
``` 
De VM zal nu rebooten.


Login op de VM en test cowsay:
```
cowsay Hallo Wereld!
```
Je zag nu dat alle lagen zijn gedownload van de bootable container image om cowsay te installeren.


Pas de dnf install -y regel in Containerfile aan:
```
dnf install -y cowsay lolcat
```
Bouw de container en push naar GHCR:
```
podman build -t ghcr.io/$NAMESPACE/bootc-simple-demo:latest .
podman push ghcr.io/$NAMESPACE/bootc-simple-demo:latest
```
Login on de VM en update de bootable container image:
```
ssh -p 2222 core@localhost
sudo bootc upgrade --apply
```
Nu is een laag bijgewerkt en de VM zal nu rebooten.

Login op de VM en test cowsay en lolcat:
```
cowsay Hallo Wereld! | lolcat
```


De huidige manier om een pakket te installeren is niet ideaal. Maar het voordeel is als je naar een nieuwe Fedora versie gaat, je alleen de FROM regel hoeft aan te passen in Containerfile.


Ga naar een nieuwere versie van Fedora:
```
FROM quay.io/fedora/fedora-bootc:42

```

Bouw de container en push naar GHCR:
```
podman build -t ghcr.io/$NAMESPACE/bootc-simple-demo:latest .  
podman push ghcr.io/$NAMESPACE/bootc-simple-demo:latest
```
Login on de VM en update de bootable container image:
```
ssh -p 2222 core@localhost
sudo bootc upgrade --apply
```
Nu is de basis laag bijgewerkt en de VM zal nu rebooten.    
Login op de VM en test cowsay:
```
cowsay Hallo Wereld! | lolcat
```
Check de Fedora versie:
```
cat /etc/fedora-release
```
Je ziet nu dat de Fedora versie 42 is en dat alle lagen zijn gedownload van de bootable container image om cowsay en lolcat te installeren. 
