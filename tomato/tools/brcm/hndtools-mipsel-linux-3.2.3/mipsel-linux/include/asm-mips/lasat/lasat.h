/*
 * lasat.h
 *
 * Thomas Horsten <thh@lasat.com>
 * Copyright (C) 2000 LASAT Networks A/S.
 *
 * ########################################################################
 *
 *  This program is free software; you can distribute it and/or modify it
 *  under the terms of the GNU General Public License (Version 2) as
 *  published by the Free Software Foundation.
 *
 *  This program is distributed in the hope it will be useful, but WITHOUT
 *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 *  for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
 *
 * ########################################################################
 *
 * Configuration for LASAT boards, loads the appropriate include files.
 *
 */
#ifndef _LASAT_H
#define _LASAT_H

#include <linux/config.h>

/*
 * Configuration block magic word(s)
 */
#define LASAT_CONFIG_MAGIC     ('L'|('C'<<8)|('B'<<16)|('2'<<24)) /* LCB2 */
#define LASAT_CONFIG_MAGIC_INT ('L'|('C'<<8)|('B'<<16)|('x'<<24)) /* LCBx */

#ifndef _LANGUAGE_ASSEMBLY
#include <linux/types.h>

extern struct lasat_misc {
	volatile u32 *reset_reg;
	volatile u32 *flash_wp_reg;
	u32 flash_wp_bit;
} *lasat_misc;

/*
 * The format of the data record in the EEPROM.
 * See Documentation/LASAT/eeprom.txt for a detailed description
 * of the fields in this struct, and the LASAT Hardware Configuration
 * field specification for a detailed description of the config
 * field.
 */
#include <linux/types.h>

#define LASAT_EEPROM_VERSION 7
struct lasat_eeprom_struct {
	unsigned int  version;
	unsigned int  cfg[3];
	unsigned char hwaddr[6];
	unsigned char print_partno[12];
	unsigned char term0;
	unsigned char print_serial[14];
	unsigned char term1;
	unsigned char prod_partno[12];
	unsigned char term2;
	unsigned char prod_serial[14];
	unsigned char term3;
	unsigned char passwd_hash[16];
	unsigned char pwdnull;
	unsigned char vendid;
	unsigned char ts_ref;
	unsigned char ts_signoff;
	unsigned char reserved[11];
	unsigned char debugaccess;
	unsigned short prid;
	unsigned int  serviceflag;
	unsigned int  ipaddr;
	unsigned int  netmask;
	unsigned int  crc32;
};

struct lasat_eeprom_struct_pre7 {
	unsigned int  version;
	unsigned int  flags[3];
	unsigned char hwaddr0[6];
	unsigned char hwaddr1[6];
	unsigned char print_partno[9];
	unsigned char term0;
	unsigned char print_serial[14];
	unsigned char term1;
	unsigned char prod_partno[9];
	unsigned char term2;
	unsigned char prod_serial[14];
	unsigned char term3;
	unsigned char passwd_hash[24];
	unsigned char pwdnull;
	unsigned char vendor;
	unsigned char ts_ref;
	unsigned char ts_signoff;
	unsigned char reserved[6];
	unsigned int  writecount;
	unsigned int  ipaddr;
	unsigned int  netmask;
	unsigned int  crc32;
};

/* Configuration descriptor encoding - see the doc for details */

#define LASAT_W0_DSCTYPE(v)		( ( (v)         ) & 0xf )
#define LASAT_W0_BMID(v)		( ( (v) >> 0x04 ) & 0xf )
#define LASAT_W0_CPUTYPE(v)		( ( (v) >> 0x08 ) & 0xf )
#define LASAT_W0_BUSSPEED(v)		( ( (v) >> 0x0c ) & 0xf )
#define LASAT_W0_CPUCLK(v)		( ( (v) >> 0x10 ) & 0xf )
#define LASAT_W0_SDRAMBANKSZ(v)		( ( (v) >> 0x14 ) & 0xf )
#define LASAT_W0_SDRAMBANKS(v)		( ( (v) >> 0x18 ) & 0xf )
#define LASAT_W0_L2CACHE(v)		( ( (v) >> 0x1c ) & 0xf )

#define LASAT_W1_EDHAC(v)		( ( (v)         ) & 0xf )
#define LASAT_W1_HIFN(v)		( ( (v) >> 0x04 ) & 0x1 )
#define LASAT_W1_ISDN(v)		( ( (v) >> 0x05 ) & 0x1 )
#define LASAT_W1_IDE(v)			( ( (v) >> 0x06 ) & 0x1 )
#define LASAT_W1_HDLC(v)		( ( (v) >> 0x07 ) & 0x1 )
#define LASAT_W1_USVERSION(v)		( ( (v) >> 0x08 ) & 0x1 )
#define LASAT_W1_4MACS(v)		( ( (v) >> 0x09 ) & 0x1 )
#define LASAT_W1_EXTSERIAL(v)		( ( (v) >> 0x0a ) & 0x1 )
#define LASAT_W1_FLASHSIZE(v)		( ( (v) >> 0x0c ) & 0xf )
#define LASAT_W1_PCISLOTS(v)		( ( (v) >> 0x10 ) & 0xf )
#define LASAT_W1_PCI1OPT(v)		( ( (v) >> 0x14 ) & 0xf )
#define LASAT_W1_PCI2OPT(v)		( ( (v) >> 0x18 ) & 0xf )
#define LASAT_W1_PCI3OPT(v)		( ( (v) >> 0x1c ) & 0xf )

/* Routines specific to LASAT boards */

#define LASAT_BMID_MASQUERADE2		0
#define LASAT_BMID_MASQUERADEPRO	1
#define LASAT_BMID_SAFEPIPE25			2
#define LASAT_BMID_SAFEPIPE50			3
#define LASAT_BMID_SAFEPIPE100		4
#define LASAT_BMID_SAFEPIPE5000		5
#define LASAT_BMID_SAFEPIPE7000		6
#define LASAT_BMID_SAFEPIPE1000		7
//#define LASAT_BMID_SAFEPIPE30		7
//#define LASAT_BMID_SAFEPIPE5100	8
//#define LASAT_BMID_SAFEPIPE7100	9
#define LASAT_BMID_UNKNOWN				0xf
#define LASAT_MAX_BMID_NAMES			9   // no larger than 15!

#define LASAT_HAS_EDHAC			( 1 << 0 )
#define LASAT_EDHAC_FAST		( 1 << 1 )
#define LASAT_HAS_EADI			( 1 << 2 )
#define LASAT_HAS_HIFN			( 1 << 3 )
#define LASAT_HAS_ISDN			( 1 << 4 )
#define LASAT_HAS_LEASEDLINE_IF		( 1 << 5 )
#define LASAT_HAS_HDC			( 1 << 6 )

#define LASAT_PRID_MASQUERADE2		0
#define LASAT_PRID_MASQUERADEPRO	1
#define LASAT_PRID_SAFEPIPE25			2
#define LASAT_PRID_SAFEPIPE50			3
#define LASAT_PRID_SAFEPIPE100		4
#define LASAT_PRID_SAFEPIPE5000		5
#define LASAT_PRID_SAFEPIPE7000		6
#define LASAT_PRID_SAFEPIPE30			7
#define LASAT_PRID_SAFEPIPE5100		8
#define LASAT_PRID_SAFEPIPE7100		9

#define LASAT_PRID_SAFEPIPE1110		10
#define LASAT_PRID_SAFEPIPE3020		11
#define LASAT_PRID_SAFEPIPE3030		12
#define LASAT_PRID_SAFEPIPE5020		13
#define LASAT_PRID_SAFEPIPE5030		14
#define LASAT_PRID_SAFEPIPE1120		15
#define LASAT_PRID_SAFEPIPE1130		16
#define LASAT_PRID_SAFEPIPE6010		17
#define LASAT_PRID_SAFEPIPE6110		18
#define LASAT_PRID_SAFEPIPE6210		19
#define LASAT_PRID_SAFEPIPE1020		20
#define LASAT_PRID_SAFEPIPE1040		21
#define LASAT_PRID_SAFEPIPE1060		22

struct lasat_info {
	unsigned int  li_cpu_hz;
	unsigned int  li_bus_hz;
	unsigned int  li_flags;
	unsigned int  li_bmid;
	unsigned int  li_memsize;
	unsigned int  li_flash_size;
	unsigned int  li_edhac;
	unsigned int  li_eadi;
	unsigned int  li_hifn;
	unsigned int  li_isdn;
	unsigned int  li_ide;
	unsigned int  li_hdlc;
	unsigned int  li_leasedline;
	unsigned int  li_usversion;
	unsigned int  li_hw_flags;
	unsigned int  li_vendid;
	unsigned int  li_prid;
	unsigned char li_bmstr[16];
	unsigned char li_vendstr[32];
	unsigned char li_namestr[32];
	unsigned char li_typestr[16];
	unsigned char li_partno[13];
	unsigned char li_serial[15];
	unsigned int  li_vpn_kbps;	/* kbit/s */
	unsigned int  li_vpn_tunnels;
	unsigned int  li_vpn_clients;
	/* Info on the Flash layout */
	unsigned int  li_flash_base;
	unsigned int  li_flash_service_base;
	unsigned int  li_flash_service_size;
	unsigned int  li_flash_normal_base;
	unsigned int  li_flash_normal_size;
	unsigned int  li_flash_cfg_base;
	unsigned int  li_flash_cfg_size;
	unsigned int  li_flash_fs_base;
	unsigned int  li_flash_fs_size;
	unsigned int  li_flash_fs2_base;
	unsigned int  li_flash_fs2_size;
	struct lasat_eeprom_struct li_eeprom_info;
	unsigned int  li_eeprom_upgrade_version;
	unsigned int  li_debugaccess;
};

extern struct lasat_info lasat_board_info;

/* Called from setup() to initialize the global board_info struct */
extern int lasat_init_board_info(void);

/* Write the modified EEPROM info struct */
extern void lasat_write_eeprom_info(void);

#define N_MACHTYPES		2
/* for calibration of delays */

#include <asm/delay.h>
#define NANOTH 1000000000L
extern inline void ndelay(unsigned int ns) {
	if (ns != 0)
		__delay(lasat_board_info.li_cpu_hz / 2 / (NANOTH / ns) + 1);
}

#endif /* !defined (_LANGUAGE_ASSEMBLY) */

/* Lasat 100 boards */
#define LASAT_GT_BASE           (KSEG1ADDR(0x14000000))

/* Lasat 200 boards */
#define Vrc5074_PHYS_BASE       0x1fa00000
#define Vrc5074_BASE            (KSEG1ADDR(Vrc5074_PHYS_BASE))
#define PCI_WINDOW1             0x1a000000

#endif /* _LASAT_H */
