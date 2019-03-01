#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=<path to>/devkitpro")
endif

TOPDIR ?= $(CURDIR)
include $(DEVKITPRO)/libnx/switch_rules

#---------------------------------------------------------------------------------
# TARGET is the name of the output
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# DATA is a list of directories containing data files
# INCLUDES is a list of directories containing header files
# EXEFS_SRC is the optional input directory containing data copied into exefs, if anything this normally should only contain "main.npdm".
# ROMFS is the directory containing data to be added to RomFS, relative to the Makefile (Optional)
#
# NO_ICON: if set to anything, do not use icon.
# NO_NACP: if set to anything, no .nacp file is generated.
# APP_TITLE is the name of the app stored in the .nacp file (Optional)
# APP_AUTHOR is the author of the app stored in the .nacp file (Optional)
# APP_VERSION is the version of the app stored in the .nacp file (Optional)
# APP_TITLEID is the titleID of the app stored in the .nacp file (Optional)
# ICON is the filename of the icon (.jpg), relative to the project folder.
#   If not set, it attempts to use one of the following (in this order):
#     - <Project name>.jpg
#     - icon.jpg
#     - <libnx folder>/default_icon.jpg
#---------------------------------------------------------------------------------
TARGET		:=	AvP_Gold
BUILD		:=	build
SOURCES		:=  source
DATA		:=	data
INCLUDES	:=	-Isrc/include -Isrc/avp -Isrc/avp/win95 -Isrc/avp/win95/gadgets -Isrc/avp/support -Isrc/avp/win95/frontend -Isrc/win95 -Isrc -I../openal-soft/include
EXEFS_SRC	:=	exefs_src
#ROMFS	:=	romfs

APP_TITLE := Alien vs. Predator Gold
APP_VERSION := 0.0.2
APP_AUTHOR := M4xw, (c) 1999-2000 Rebellion

#---------------------------------------------------------------------------------
# options for code generation
#---------------------------------------------------------------------------------
ARCH	:=	-march=armv8-a -mtune=cortex-a57 -mtp=soft -fPIE

DEFINES := -DUSE_OPENGL_ES=1 

CFLAGS	:=	-g -Wall -O3 -ftree-vectorize -ffast-math -funsafe-math-optimizations -ffunction-sections \
			$(ARCH) $(DEFINES)

CFLAGS	+=	-D__SWITCH__ $(INCLUDES) `sdl2-config --cflags`

CXXFLAGS	:= $(CFLAGS) -fno-rtti -fno-exceptions

ASFLAGS	:=	-g $(ARCH)
LDFLAGS	=	-specs=$(DEVKITPRO)/libnx/switch.specs -g $(ARCH) -Wl,-Map,$(notdir $*.map)

LIBS	:=	`sdl2-config --libs` -L../openal-soft/lib -lopenal-soft -lswresample -lswscale -lavformat -lavcodec -lavutil -lz -lm -lbz2

#---------------------------------------------------------------------------------
# list of directories containing libraries, this must be the top level containing
# include and lib
#---------------------------------------------------------------------------------
LIBDIRS	:= $(PORTLIBS) $(LIBNX)

export OUTPUT	:=	$(CURDIR)/$(TARGET)
export TOPDIR	:=	$(CURDIR)

export VPATH	:=	$(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) \
			$(foreach dir,$(DATA),$(CURDIR)/$(dir))

export DEPSDIR	:=	$(CURDIR)

CFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
BINFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.*)))

export LD	:=	$(CXX)

export OFILES_BIN	:=	$(addsuffix .o,$(BINFILES))
export OFILES_SRC	:=	$(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)

export OFILES 	:=	src/avp/ai_sight.o \
					src/avp/avpview.o \
					src/avp/bh_agun.o \
					src/avp/bh_ais.o \
					src/avp/bh_alien.o \
					src/avp/bh_binsw.o \
					src/avp/bh_cable.o \
					src/avp/bh_corpse.o \
					src/avp/bh_deathvol.o \
					src/avp/bh_debri.o \
					src/avp/bh_dummy.o \
					src/avp/bh_fan.o \
					src/avp/bh_far.o \
					src/avp/bh_fhug.o \
					src/avp/bh_gener.o \
					src/avp/bh_ldoor.o \
					src/avp/bh_lift.o \
					src/avp/bh_light.o \
					src/avp/bh_lnksw.o \
					src/avp/bh_ltfx.o \
					src/avp/bh_marin.o \
					src/avp/bh_mission.o \
					src/avp/bh_near.o \
					src/avp/bh_pargen.o \
					src/avp/bh_plachier.o \
					src/avp/bh_plift.o \
					src/avp/bh_pred.o \
					src/avp/bh_queen.o \
					src/avp/bh_rubberduck.o \
					src/avp/bh_selfdest.o \
					src/avp/bh_snds.o \
					src/avp/bh_spcl.o \
					src/avp/bh_swdor.o \
					src/avp/bh_track.o \
					src/avp/bh_types.o \
					src/avp/bh_videoscreen.o \
					src/avp/bh_waypt.o \
					src/avp/bh_weap.o \
					src/avp/bh_xeno.o \
					src/avp/bonusabilities.o \
					src/avp/cconvars.o \
					src/avp/cdtrackselection.o \
					src/avp/cheatmodes.o \
					src/avp/comp_map.o \
					src/avp/comp_shp.o \
					src/avp/consolelog.o \
					src/avp/davehook.o \
					src/avp/deaths.o \
					src/avp/decal.o \
					src/avp/detaillevels.o \
					src/avp/dynamics.o \
					src/avp/dynblock.o \
					src/avp/equipmnt.o \
					src/avp/extents.o \
					src/avp/game.o \
					src/avp/game_statistics.o \
					src/avp/gamecmds.o \
					src/avp/gamevars.o \
					src/avp/hmodel.o \
					src/avp/hud.o \
					src/avp/inventry.o \
					src/avp/language.o \
					src/avp/lighting.o \
					src/avp/load_shp.o \
					src/avp/los.o \
					src/avp/mempool.o \
					src/avp/messagehistory.o \
					src/avp/missions.o \
					src/avp/movement.o \
					src/avp/paintball.o \
					src/avp/particle.o \
					src/avp/pfarlocs.o \
					src/avp/pheromon.o \
					src/avp/player.o \
					src/avp/pmove.o \
					src/avp/psnd.o \
					src/avp/psndproj.o \
					src/avp/pvisible.o \
					src/avp/savegame.o \
					src/avp/scream.o \
					src/avp/secstats.o \
					src/avp/sfx.o \
					src/avp/shapes/cube.o \
					src/avp/stratdef.o \
					src/avp/support/consbind.o \
					src/avp/support/consbtch.o \
					src/avp/support/coordstr.o \
					src/avp/support/daemon.o \
					src/avp/support/indexfnt.o \
					src/avp/support/r2base.o \
					src/avp/support/r2pos666.o \
					src/avp/support/reflist.o \
					src/avp/support/refobj.o \
					src/avp/support/rentrntq.o \
					src/avp/support/scstring.o \
					src/avp/support/strtab.o \
					src/avp/support/strutil.o \
					src/avp/support/trig666.o \
					src/avp/support/wrapstr.o \
					src/avp/targeting.o \
					src/avp/track.o \
					src/avp/triggers.o \
					src/avp/weapons.o \
					src/avp/win95/avpchunk.o \
					src/avp/win95/cheat.o \
					src/avp/win95/chtcodes.o \
					src/avp/win95/d3d_hud.o \
					src/avp/win95/ddplat.o \
					src/avp/win95/endianio.o \
					src/avp/win95/ffread.o \
					src/avp/win95/ffstdio.o \
					src/avp/win95/frontend/avp_envinfo.o \
					src/avp/win95/frontend/avp_intro.o \
					src/avp/win95/frontend/avp_menudata.o \
					src/avp/win95/frontend/avp_menus.o \
					src/avp/win95/frontend/avp_mp_config.o \
					src/avp/win95/frontend/avp_userprofile.o \
					src/avp/win95/gadgets/ahudgadg.o \
					src/avp/win95/gadgets/conscmnd.o \
					src/avp/win95/gadgets/conssym.o \
					src/avp/win95/gadgets/consvar.o \
					src/avp/win95/gadgets/gadget.o \
					src/avp/win95/gadgets/hudgadg.o \
					src/avp/win95/gadgets/rootgadg.o \
					src/avp/win95/gadgets/t_ingadg.o \
					src/avp/win95/gadgets/teletype.o \
					src/avp/win95/gadgets/textexp.o \
					src/avp/win95/gadgets/textin.o \
					src/avp/win95/gadgets/trepgadg.o \
					src/avp/win95/gammacontrol.o \
					src/avp/win95/hierplace.o \
					src/avp/win95/iofocus.o \
					src/avp/win95/jsndsup.o \
					src/avp/win95/kzsort.o \
					src/avp/win95/langplat.o \
					src/avp/win95/modcmds.o \
					src/avp/win95/npcsetup.o \
					src/avp/win95/objsetup.o \
					src/avp/win95/pathchnk.o \
					src/avp/win95/platsup.o \
					src/avp/win95/pldghost.o \
					src/avp/win95/pldnet.o \
					src/avp/win95/progress_bar.o \
					src/avp/win95/projload.o \
					src/avp/win95/scrshot.o \
					src/avp/win95/strachnk.o \
					src/avp/win95/system.o \
					src/avp/win95/usr_io.o \
					src/avp/win95/vision.o \
					src/bink.o \
					src/cdplayer.o \
					src/files.o \
					src/fmv.o \
					src/frustum.o \
					src/kshape.o \
					src/main.o \
					src/map.o \
					src/mathline.o \
					src/maths.o \
					src/md5.o \
					src/mem3dc.o \
					src/mem3dcpp.o \
					src/menus.o \
					src/module.o \
					src/morph.o \
					src/net.o \
					src/nxlink.o \
					src/object.o \
					src/oglfunc.o \
					src/openal.o \
					src/opengl.o \
					src/shpanim.o \
					src/sphere.o \
					src/stubs.o \
					src/tables.o \
					src/vdb.o \
					src/version.o \
					src/win95/animchnk.o \
					src/win95/animobs.o \
					src/win95/awbmpld.o \
					src/win95/awiffld.o \
					src/win95/awpnmld.o \
					src/win95/awtexld.o \
					src/win95/bmpnames.o \
					src/win95/chnkload.o \
					src/win95/chnktexi.o \
					src/win95/chnktype.o \
					src/win95/chunk.o \
					src/win95/chunkpal.o \
					src/win95/db.o \
					src/win95/debuglog.o \
					src/win95/dummyobjectchunk.o \
					src/win95/enumchnk.o \
					src/win95/enumsch.o \
					src/win95/envchunk.o \
					src/win95/fail.o \
					src/win95/fragchnk.o \
					src/win95/gsprchnk.o \
					src/win95/hierchnk.o \
					src/win95/huffman.o \
					src/win95/iff.o \
					src/win95/iff_ilbm.o \
					src/win95/ilbm_ext.o \
					src/win95/io.o \
					src/win95/list_tem.o \
					src/win95/ltchunk.o \
					src/win95/media.o \
					src/win95/mishchnk.o \
					src/win95/obchunk.o \
					src/win95/oechunk.o \
					src/win95/our_mem.o \
					src/win95/plat_shp.o \
					src/win95/plspecfn.o \
					src/win95/shpchunk.o \
					src/win95/sndchunk.o \
					src/win95/sprchunk.o \
					src/win95/string.o \
					src/win95/texio.o \
					src/win95/toolchnk.o \
					src/win95/txioctrl.o \
					src/win95/wpchunk.o \
					src/win95/zsp.o \
					src/winapi.o

export OBJ := $(OFILES)
export HFILES_BIN	:=	$(addsuffix .h,$(subst .,_,$(BINFILES)))

export INCLUDE	:=	$(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
			$(foreach dir,$(LIBDIRS),-I$(dir)/include) \
			-I$(CURDIR)/$(BUILD)

export LIBPATHS	:=	$(foreach dir,$(LIBDIRS),-L$(dir)/lib)

export BUILD_EXEFS_SRC := $(TOPDIR)/$(EXEFS_SRC)

ifeq ($(strip $(ICON)),)
	icons := $(wildcard *.jpg)
	ifneq (,$(findstring $(TARGET).jpg,$(icons)))
		export APP_ICON := $(TOPDIR)/$(TARGET).jpg
	else
		ifneq (,$(findstring icon.jpg,$(icons)))
			export APP_ICON := $(TOPDIR)/icon.jpg
		endif
	endif
else
	export APP_ICON := $(TOPDIR)/$(ICON)
endif

ifeq ($(strip $(NO_ICON)),)
	export NROFLAGS += --icon=$(APP_ICON)
endif

ifeq ($(strip $(NO_NACP)),)
	export NROFLAGS += --nacp=$(CURDIR)/$(TARGET).nacp
endif

ifneq ($(APP_TITLEID),)
	export NACPFLAGS += --titleid=$(APP_TITLEID)
endif

ifneq ($(ROMFS),)
	export NROFLAGS += --romfsdir=$(CURDIR)/$(ROMFS)
endif

DEPENDS	:=	$(OFILES:.o=.d)

#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------
all	:	$(OUTPUT).pfs0 $(OUTPUT).nro

$(OUTPUT).pfs0	:	$(OUTPUT).nso

$(OUTPUT).nso	:	$(OUTPUT).elf

ifeq ($(strip $(NO_NACP)),)
$(OUTPUT).nro	:	$(OUTPUT).elf $(OUTPUT).nacp
else
$(OUTPUT).nro	:	$(OUTPUT).elf
endif

$(OUTPUT).elf	:	$(OFILES)

$(OFILES_SRC)	: $(HFILES_BIN)

clean:
	@echo clean ...
	@rm -fr $(OBJ) $(OUTPUT).pfs0 $(OUTPUT).nso $(OUTPUT).nro $(OUTPUT).nacp $(OUTPUT).elf

#---------------------------------------------------------------------------------
# you need a rule like this for each extension you use as binary data
#---------------------------------------------------------------------------------
%.bin.o	%_bin.h :	%.bin
#---------------------------------------------------------------------------------
	@echo $(notdir $<)
	@$(bin2o)

-include $(DEPENDS)
