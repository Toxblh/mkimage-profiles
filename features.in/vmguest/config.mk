+vmguest: use/vmguest/vbox use/vmguest/kvm use/vmguest/vmware; @:

use/vmguest:
	@$(call add_feature)

use/vmguest/vbox: use/vmguest
	@$(call add,THE_KMODULES,virtualbox-addition vboxguest drm)
	@$(call add,THE_PACKAGES,virtualbox-guest-additions)

# NB: only reasonable for X11-bearing images
# see also use/install2/kvm
use/vmguest/kvm: use/vmguest
	@$(call add,THE_PACKAGES,spice-vdagent)

# see also use/install2/vmware
use/vmguest/vmware:
	@$(call add,THE_KMODULES,scsi)	# mptspi.ko
