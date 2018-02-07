# NB: A copy of ../../live/lib/50-aptprefs.mk.
# TODO: Manage things to make duplicate files unnecessary.

_IMAGE_APTBOX_ = $(WORKDIR)/chroot/$(WORKDIRNAME)/aptbox

# Add prerequisite to the `build-image` target of
# $(MKIMAGE_PREFIX)/targets.mk.
build-image: $(_IMAGE_APTBOX_)/etc/apt/pkgpriorities

_PINNED_PACKAGES_ = $(foreach pp,$(PINNED_PACKAGES),$(if $(findstring :,$(pp)),$(pp),$(pp):$(PIN_PRIORITY)))
_PIN_PRIORITIES_ = $(sort $(foreach pp,$(_PINNED_PACKAGES_),$(lastword $(subst :, ,$(pp)))))
_PKGPRIORITIES_ = $(subst \n ,\n,$(foreach pri,$(_PIN_PRIORITIES_),$(pri):$(patsubst %:$(pri),\n   %,$(filter %:$(pri),$(_PINNED_PACKAGES_)))\n))

$(_IMAGE_APTBOX_)/etc/apt/pkgpriorities: prepare-image-workdir
	@echo -e '$(_PKGPRIORITIES_)' | sed -e 's/[[:space:]]\+$$//' >$@
	@if [ -s $@ ]; then \
		if grep -q '^\(APT::\)\?Dir::Etc::pkgpriorities[[:space:]]' \
			$(_IMAGE_APTBOX_)/etc/apt/apt.conf; \
		then \
			sed -i -e 's/\(Dir::Etc::pkgpriorities\)[[:space:]].*$$/\1 "$@";/g' \
				$(_IMAGE_APTBOX_)/etc/apt/apt.conf; \
		else \
			echo 'Dir::Etc::pkgpriorities "$@";' \
				>>$(_IMAGE_APTBOX_)/etc/apt/apt.conf; \
		fi; \
		echo "--- Package priorities ---" >&2; \
		cat $@ >&2; \
		echo "---" >&2; \
	fi
