#include <kern/e1000.h>
#include <kern/pmap.h>
#include <inc/string.h>
#include <inc/error.h>

static struct E1000 *base;

struct tx_desc *tx_descs;
#define N_TXDESC (PGSIZE / sizeof(struct tx_desc))
char tx_buffer[N_TXDESC][TX_PKT_SIZE];

int
e1000_tx_init()
{
	int r;
	// Allocate one page for descriptors
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
	tx_descs = (struct tx_desc *)page2kva(page);
	// Initialize all descriptors
	for(int i = 0; i < N_TXDESC; i++){
		tx_descs[i].addr = PADDR(tx_buffer[i]);
		tx_descs[i].cmd |= E1000_TX_CMD_EOP|E1000_TX_CMD_RS;
		tx_descs[i].status |= E1000_TX_STATUS_DD;
		tx_descs[i].length = 0;
		tx_descs[i].cso = 0;
		tx_descs[i].css = 0;
		tx_descs[i].special = 0;
	}
	// Set hardware registers
	// Look kern/e1000.h to find useful definations
	//lab6 bug?
	base->TDBAL = (uint32_t)PADDR(tx_descs);
	base->TDBAH = (uint32_t)0;
	// base->TDLEN = N_TXDESC * sizeof(struct tx_desc); 
	base->TDLEN = N_TXDESC * sizeof(struct tx_desc);

	base->TDH = 0;
	base->TDT = 0;

	base->TCTL |= E1000_TCTL_EN|E1000_TCTL_PSP|E1000_TCTL_CT_ETHER|E1000_TCTL_COLD_FULL_DUPLEX;
	base->TIPG = E1000_TIPG_DEFAULT;
	return 0;
}

struct rx_desc *rx_descs;
#define N_RXDESC (PGSIZE / sizeof(struct rx_desc))
char rx_buffer[N_RXDESC][RX_PKT_SIZE];
int
e1000_rx_init()
{
	cprintf("in %s\n",__FUNCTION__);
	int r;
	// Allocate one page for descriptors
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
	if(page == NULL)
			panic("page_alloc panic\n");
	rx_descs = (struct rx_desc *)page2kva(page);
	// Initialize all descriptors
	// You should allocate some pages as receive buffer
	for(int i = 0; i < N_RXDESC; i++){
		rx_descs[i].addr = PADDR(rx_buffer[i]);
	}
	// Set hardward registers
	// Look kern/e1000.h to find useful definations
	//lab6 bug?
	base->RCTL |= E1000_RCTL_EN|E1000_RCTL_BSIZE_2048|E1000_RCTL_SECRC;
	base->RDBAL = PADDR(rx_descs);
	base->RDBAH = (uint32_t)0;
	base->RDLEN = N_RXDESC* sizeof(struct rx_desc);
	base->RDH = 0;
	base->RDT = N_RXDESC-1;
	base->RAL = QEMU_MAC_LOW;
	base->RAH = QEMU_MAC_HIGH;

	return 0;
}

int
pci_e1000_attach(struct pci_func *pcif)
{
	cprintf("in %s\n", __FUNCTION__);
	// Enable PCI function
	// Map MMIO region and save the address in 'base;
	pci_func_enable(pcif);
	
	base = (struct E1000 *)mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
	e1000_tx_init();
	e1000_rx_init();

	return 0;
}

int
e1000_tx(const void *buf, uint32_t len)
{
	// Send 'len' bytes in 'buf' to ethernet
	// Hint: buf is a kernel virtual address
	cprintf("in %s\n", __FUNCTION__);
	if(tx_descs[base->TDT].status & E1000_TX_STATUS_DD){
		tx_descs[base->TDT].status ^= E1000_TX_STATUS_DD;
		memset(KADDR(tx_descs[base->TDT].addr), 0 , TX_PKT_SIZE);
		memcpy(KADDR(tx_descs[base->TDT].addr), buf, len);
		tx_descs[base->TDT].length = len;
		tx_descs[base->TDT].cmd |= E1000_TX_CMD_EOP|E1000_TX_CMD_RS;

		base->TDT = (base->TDT + 1)%N_TXDESC;
	}
	else{
		return -E_TX_FULL;
	}
	return 0;
}

// char rx_bufs[N_RXDESC][RX_PKT_SIZE];

int
e1000_rx(void *buf, uint32_t len)
{
	// Copy one received buffer to buf
	// You could return -E_AGAIN if there is no packet
	// Check whether the buf is large enough to hold
	// the packet
	// Do not forget to reset the decscriptor and
	// give it back to hardware by modifying RDT

	// if(rx_descs[base->RDH].status & E1000_RX_STATUS_DD){
	// 	rx_descs[base->RDH].status ^= E1000_RX_STATUS_DD;
	// 	assert(len > rx_descs[base->RDH].length);
	// 	memcpy(buf, KADDR(rx_descs[base->RDH].addr), len);
	// 	memset(KADDR(rx_descs[base->RDH].addr), 0, PKT_SIZE);
	// 	base->RDT = base->RDH;
	// }
	uint32_t rdt = (base->RDT + 1) % N_RXDESC;
  	if(!(rx_descs[rdt].status & E1000_RX_STATUS_DD)){
		return -E_AGAIN;
	}

	if(rx_descs[rdt].error) {
		cprintf("[rx]error occours\n");
		return -E_UNSPECIFIED;
	}
	len = rx_descs[rdt].length;
  	memcpy(buf, rx_buffer[rdt], rx_descs[rdt].length);
  	rx_descs[rdt].status ^= E1000_RX_STATUS_DD;//lab6 bug?

  	base->RDT = rdt;
	return len;
}
