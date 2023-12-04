PACKER_VERSION=1.7.2
PWN_HOSTNAME=pwnagotchi
PWN_VERSION=master

all: clean install image

langs:
        @for lang in pwnagotchi/locale/*/; do\
                echo "compiling language: $$lang ..."; \
                ./scripts/language.sh compile $$(basename $$lang); \
    done

install:
        curl https://releases.hashicorp.com/packer/1.7.2/packer_1.7.2_linux_amd64.zip -o /tmp/packer.zip
        unzip /tmp/packer.zip -d /tmp
        sudo mv /tmp/packer /usr/bin/packer
        git clone https://github.com/solo-io/packer-plugin-arm-image /tmp/packer-plugin-arm-image
        cd /tmp/packer-plugin-arm-image && go get -d ./... && go build
        sudo cp /tmp/packer-plugin-arm-image/packer-plugin-arm-image /usr/bin

image:
        cd builder && sudo /usr/bin/packer build -var "pwn_hostname=pwnagotchi" -var "pwn_version=master" pwnagotchi.json
        sudo mv builder/output-pwnagotchi/image pwnagotchi-raspberrypi-os-lite-master.img
        sudo sha256sum pwnagotchi-raspberrypi-os-lite-$(PWN_VERSION).img > pwnagotchi-raspberrypi-os-lite-$(PWN_VERSION).sha256
        sudo zip pwnagotchi-raspberrypi-os-lite-$(PWN_VERSION).zip pwnagotchi-raspberrypi-os-lite-master.sha256 pwnagotchi-raspberrypi-os-lite-$(P>

clean:
        rm -rf /tmp/packer-builder-arm-image
        rm -f pwnagotchi-raspberrypi-os-lite-*.zip pwnagotchi-raspberrypi-os-lite-*.img pwnagotchi-raspberrypi-os-lite-*.sha256
        rm -rf builder/output-pwnagotchi  builder/packer_cache

