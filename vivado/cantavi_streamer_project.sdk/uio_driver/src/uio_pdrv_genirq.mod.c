#include <linux/module.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

MODULE_INFO(vermagic, VERMAGIC_STRING);
MODULE_INFO(name, KBUILD_MODNAME);

__visible struct module __this_module
__attribute__((section(".gnu.linkonce.this_module"))) = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};

static const struct modversion_info ____versions[]
__used
__attribute__((section("__versions"))) = {
	{ 0xe71b394a, __VMLINUX_SYMBOL_STR(module_layout) },
	{ 0x1c2f702, __VMLINUX_SYMBOL_STR(param_ops_string) },
	{ 0x737ce55a, __VMLINUX_SYMBOL_STR(platform_driver_unregister) },
	{ 0x578939f4, __VMLINUX_SYMBOL_STR(__platform_driver_register) },
	{ 0x934a7792, __VMLINUX_SYMBOL_STR(__uio_register_device) },
	{ 0x6a7f8176, __VMLINUX_SYMBOL_STR(pm_runtime_enable) },
	{ 0x62da00f9, __VMLINUX_SYMBOL_STR(dev_warn) },
	{ 0xf1b6e319, __VMLINUX_SYMBOL_STR(platform_get_irq) },
	{ 0xd7545cd3, __VMLINUX_SYMBOL_STR(dev_err) },
	{ 0x85e03912, __VMLINUX_SYMBOL_STR(devm_kmalloc) },
	{ 0x5fc56a46, __VMLINUX_SYMBOL_STR(_raw_spin_unlock) },
	{ 0x9c0bd51f, __VMLINUX_SYMBOL_STR(_raw_spin_lock) },
	{ 0x27bbf221, __VMLINUX_SYMBOL_STR(disable_irq_nosync) },
	{ 0x51d559d1, __VMLINUX_SYMBOL_STR(_raw_spin_unlock_irqrestore) },
	{ 0xfcec0987, __VMLINUX_SYMBOL_STR(enable_irq) },
	{ 0x598542b2, __VMLINUX_SYMBOL_STR(_raw_spin_lock_irqsave) },
	{ 0x35880f6, __VMLINUX_SYMBOL_STR(__pm_runtime_resume) },
	{ 0x1be21a61, __VMLINUX_SYMBOL_STR(__pm_runtime_idle) },
	{ 0x4d10b692, __VMLINUX_SYMBOL_STR(__pm_runtime_disable) },
	{ 0xcf90d9de, __VMLINUX_SYMBOL_STR(uio_unregister_device) },
	{ 0xefd6cf06, __VMLINUX_SYMBOL_STR(__aeabi_unwind_cpp_pr0) },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";

MODULE_ALIAS("of:N*T*");
MODULE_ALIAS("of:N*T*C*");
