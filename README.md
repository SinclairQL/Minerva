Minerva
=======

A replacement ROM for Sinclair QL computers, initially developed by Laurence Reeves.

Description
-----------
This is a fork of Marcel Kilgus's 1.98a1 version, with added support for SMSQ/E-like command history.

You can now use the arrow up/down keys to browse through the command history, just like in SMSQ/E. Also, the HISTORY device has been backported from SMSQ/E so it's now also available in Minerva. Note that you can still use the AUTO command as before to enter auto-numbered lines and browse through them, in case you don't have the much more advanced Toolkit II's ED full-screen editor available.

In order to use the command history feature, the hist_bin file has to be loaded separately from your BOOT file (using the LRESPR command). Also, the I2C support for Minerva MKII has been removed to make room for the command history code.

To distinguish this Minerva build from other builds, a new subversion has been added. I'm following the convention introduced by Marcel Kilgus. VER$(-2) and MT.INF still return "1.98" for compatibility reasons, but the subversion may be read from the previously unused extended system variable at offset $4A (i.e. PEEK_W(!124!74)). The new subversion will be from 'j1' onwards. Note that this system variable has actually 4 bytes, so the extra 2 bytes at $4C may be used in the future if I might run out of single digits!

A German version for use with German keyboard layouts is also included, which is marked by having version string '1G98' rather than '1.98'.

Finally, there are two variants marked '1.98j3-w' and '1G98j3-w'. The only difference is that they try to boot from 'win1_boot' rather than 'mdv1_boot'. These can be used in emulators such as Qemulator or sQLux, so that patching by the emulator itself to boot from win1_ is not necessary.

Bugs
----
Some people have reported problems when using these ROMs in QLs with Miracle Systems Gold Card or Super Gold Card, usually resulting in failure to boot. These are likely due to the patching of the code by the ROM in the (Super) Gold Card and are under investigation.

Gold Cards (not Super Gold Cards) with ROM version 2.49 are reported to boot correctly.

Building your own version
-------------------------
The complete ROM image is ready-built. However, if you want to rebuild Minerva, you will need the following:

- a QDOS or (preferrably) SMSQ/E system on suitable hardware. A bare QL with 128K RAM and floppies won't do, you will need several megabytes of storage to assemble and link the system together. Use QPC2 or another emulator if you want more speed.
- The QMAC and QLINK macro-assembler and linker. You can download them from https://dilwyn.theqlforum.com/asm/index.html. These are enhanced versions of the GST Macro Assembler and linker, now freeware for non-commercial purposes. As an alternative for QLINK, you may also use the Qjump linker from SMSQ/E's source.
- The QMake program, also available from the download link mentioned above. This program requires the Pointer Environment (already included in SMSQ/E) and the QMenu extension (https://dilwyn.theqlforum.com/tk/qmenu805.zip) installed.
- The Make.bas SBASIC program in this repository for easy building.

You might need to do some configuration on the QMAC, QLINK, and QMake programs using the menuconfig program to get the device and directory path right. The original build used 'win1_' as base device for the whole repository, which was hardcoded in all .asm and cct files. I have stripped the base device from all 'include' directives in the .asm files, which should simplify building on any platform provided that you set the default data directory (DATA_USE statement) correctly.

Unfortunately, the cct files in each subdirectory of the M_ directory which contain the names of the individual files to be assembled and concatenated to 'lib' files must contain the full path to all '_rel' files, including the base device. Currently, this base device is set to 'dev7_'. You can use the DEV_USE command to make the dev7_ virtual device point to a directory on a physical device.

Note that it is not recommended to use a QDOS/SMSQE subdirectory as base directory, as some utilities (notably make_clean) might fail when traversing the subdirectories. It is best to either point the DEV7_ device to the base (Windows) directory of the repository, or use a separate virtual WIN drive for the repository so you can use 'WINx_' as base directory.

Using the Make.bas program
--------------------------

LRUN the program first (this will set some variables right and display the usage screen). The program contains some procedures which can be invoked separately to build parts of the package, or simply enter 'Make' to build the complete package.

- make_minerva 'version': This builds the 48K Minerva ROM. Currently, 'version' should be '1.98jx' for English or '1G98jx' for German version.
- make_rom 'version': As above, but saves the ROM image padded to 48K bytes as dev7_Minerva_version_bin.
- make: build both English and German versions
- make_history: Build history device (see README.md in the hist_ subdirectory)
- make_clean: Cleanup all generated '_REL' and 'LIB' files. It creates a log file in ram1_make_log for review.

The mincf configuration file
----------------------------

This text file is used to configure certain hardware features of Minerva while building:

- QL_IIC   Set to 1 for I2C support, 0 for no I2C support. Mutually exclusive with CMD_HIST, else the size of the ROM code will be too large (>48K)
- CMD_HIST Set to 1 to enable Command history using HISTORY device, 0 to disable.
- WIN_BOOT Set to 1 to boot from win1_, else boot from mdv1_

After editing this file, you MUST rebuild the entire Minerva ROM by issueing a 'make_clean'.