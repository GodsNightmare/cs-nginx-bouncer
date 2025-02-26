BUILD_VERSION?="$(shell git for-each-ref --sort=-v:refname --count=1 --format '%(refname)'  | cut -d '/' -f3)"
OUTDIR="cs-nginx-bouncer-${BUILD_VERSION}/"
LUA_MOD_DIR="${OUTDIR}lua-mod"
CONFIG_DIR="${OUTDIR}config"
OUT_ARCHIVE="cs-nginx-bouncer.tgz"
default: release
release: 
	git clone https://github.com/crowdsecurity/lua-cs-bouncer.git
	mkdir -p ${LUA_MOD_DIR}
	mkdir -p ${CONFIG_DIR}
	cp -r lua-cs-bouncer/lib/ "${LUA_MOD_DIR}"
	cp lua-cs-bouncer/install.sh "${LUA_MOD_DIR}"
	cp lua-cs-bouncer/template.conf "${LUA_MOD_DIR}"
	chmod +x "${LUA_MOD_DIR}/install.sh"

	cp config/crowdsec.conf "${CONFIG_DIR}"

	cp lua-cs-bouncer/uninstall.sh "${LUA_MOD_DIR}"
	chmod +x "${LUA_MOD_DIR}/uninstall.sh"

	cp install.sh ${OUTDIR}
	chmod +x ${OUTDIR}install.sh

	cp uninstall.sh ${OUTDIR}
	chmod +x ${OUTDIR}uninstall.sh

	cp upgrade.sh ${OUTDIR}
	chmod +x ${OUTDIR}upgrade.sh

	cp -r ./nginx/ ${OUTDIR}
	tar cvzf ${OUT_ARCHIVE} ${OUTDIR}
	rm -rf ${OUTDIR}
	rm -rf "lua-cs-bouncer/"

clean:
	rm -rf "${OUTDIR}"
	rm -rf "${OUT_ARCHIVE}"
	rm -rf "lua-cs-bouncer/"