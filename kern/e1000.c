#include <kern/e1000.h>
#include <kern/pmap.h>
#include <inc/string.h>
#include <inc/error.h>

static struct E1000 *base;

struct tx_desc *tx_descs;
#define N_TXDESC (PGSIZE / sizeof(struct tx_desc))
char tx_buffer[N_TXDESC][PKT_SIZE];

char transmit_packet_buffer[N_TXDESC][MAX_PKT_SIZE];

static void set_rs_bit(struct tx_desc* ptr){
    //ptr->cmd |= E1000_TX_CMD_RS;
	ptr->cmd |= 8;
}

static void set_eop_bit(struct tx_desc* ptr){
	ptr->cmd |= E1000_TX_CMD_EOP;
}

static void set_length(struct tx_desc* ptr, uint32_t len){
    ptr->length = len;
}

static void set_dd_bit(struct tx_desc* ptr){
    ptr->status |= E1000_TX_STATUS_DD;
}

static void clear_dd_bit(struct tx_desc* ptr){
    ptr->status &= (~E1000_TX_STATUS_DD);
}

static bool check_dd_bit(struct tx_desc* ptr){
    return (ptr->status & 1);
}

static uint64_t read_tdt(){
    return base->TDT;
}

static void set_tdt(uint64_t tail){
    base->TDT = tail;
}

static uint64_t read_rdh(){
    return base->RDH;
}

static void set_rdh(uint64_t head){
    base->RDH = head;
}

int
e1000_tx_init()
{
	// cprintf("in %s\n", __FUNCTION__);
	// int r;
	// // Allocate one page for descriptors
	// struct PageInfo* page = page_alloc(ALLOC_ZERO);
	// if(page == NULL)
	// 		panic("page_alloc panic\n");
	// // r = page_insert(kern_pgdir, page, page2kva(page), PTE_P|PTE_U|PTE_W|PTE_PCD|PTE_PWT);
	// // if(r < 0)
	// 	// panic("page insert panic\n");
	// tx_descs = (struct tx_desc *)page2kva(page);
	// // Initialize all descriptors
	// for(int i = 0; i < N_TXDESC; i++){
	// 	tx_descs[i].addr = PADDR(tx_buffer[i]);
	// 	tx_descs[i].cmd |= E1000_TX_CMD_EOP|E1000_TX_CMD_RS;
	// 	tx_descs[i].status |= E1000_TX_STATUS_DD;
	// 	tx_descs[i].length = 0;
	// 	tx_descs[i].cso = 0;
	// 	tx_descs[i].css = 0;
	// 	tx_descs[i].special = 0;
	// }
	// // Set hardware registers
	// // Look kern/e1000.h to find useful definations
	// //lab6 bug?
	// base->TDBAL = PADDR(tx_descs);
	// base->TDBAH = (uint32_t)0;
	// base->TDLEN = N_TXDESC * sizeof(struct tx_desc); 

	// base->TDH = 0;
	// base->TDT = 0;
	// base->TCTL |= E1000_TCTL_EN|E1000_TCTL_PSP|E1000_TCTL_CT_ETHER|E1000_TCTL_COLD_FULL_DUPLEX;
	// base->TIPG |= E1000_TIPG_DEFAULT;
	// return 0;


		// Allocate one page for descriptors
	struct PageInfo* page =  page_alloc(1);
	tx_descs = page2kva(page);
	
	// Initialize all descriptors
	for(int i = 0; i < N_TXDESC; i++){
		tx_descs[i].addr = PADDR(transmit_packet_buffer[i]);
		set_dd_bit(&tx_descs[i]);
	}

	// Set hardware registers
	// Look kern/e1000.h to find useful definations
	base->TDBAL = (uint32_t)PADDR(tx_descs);
	base->TDBAH = 0;
	base->TDLEN = N_TXDESC * sizeof(struct tx_desc);
	base->TDH = 0;
	base->TDT = 0;
	//TCTL.EN
	base->TCTL |= E1000_TCTL_EN;
	//TCTL.PSP
	base->TCTL |= E1000_TCTL_PSP;
	//base->TCTL &= ~E1000_TCTL_CT;
	//TCTL.CT
	base->TCTL |= E1000_TCTL_CT_ETHER;
	//base->TCTL &= ~E1000_TCTL_COLD;
	//TCTL.COLD
	base->TCTL |= E1000_TCTL_COLD_FULL_DUPLEX;
	//TIPG
	base->TIPG = E1000_TIPG_DEFAULT;
	return 0;
}

struct rx_desc *rx_descs;
#define N_RXDESC (PGSIZE / sizeof(struct rx_desc))
char rx_buffer[N_RXDESC][RX_PKT_SIZE];
char receive_packet_buffer[N_RXDESC][MAX_PKT_SIZE];

int
e1000_rx_init()
{
	// cprintf("in %s\n",__FUNCTION__);
	// int r;
	// // Allocate one page for descriptors
	// struct PageInfo* page = page_alloc(ALLOC_ZERO);
	// if(page == NULL)
	// 		panic("page_alloc panic\n");
	// rx_descs = (struct rx_desc *)page2kva(page);
	// // Initialize all descriptors
	// // You should allocate some pages as receive buffer
	// for(int i = 0; i < N_RXDESC; i++){
	// 	rx_descs[i].addr = PADDR(rx_buffer[i]);
	// 	// rx_descs[i].status |= E1000_RX_STATUS_DD;
	// }
	// // Set hardward registers
	// // Look kern/e1000.h to find useful definations
	// //lab6 bug?
	// base->RCTL |= E1000_RCTL_EN|E1000_RCTL_BSIZE_2048|E1000_RCTL_SECRC;
	// base->RDBAL = PADDR(rx_descs);
	// base->RDBAH = (uint32_t)0;
	// base->RDLEN = N_RXDESC* sizeof(struct rx_desc);
	// base->IMS = 0;
	// base->RDH = 1;
	// base->RDT = 0;
	// base->RAL = QEMU_MAC_LOW;
	// base->RAH = QEMU_MAC_HIGH;

	// return 0;


int r;
	// Allocate one page for descriptors
	struct PageInfo *p = page_alloc(ALLOC_ZERO);
	rx_descs = page2kva(p);

	// Initialize all descriptors
	// You should allocate some pages as receive buffer
	for (int i = 0; i < N_RXDESC; ++i) {
		rx_descs[i].addr = PADDR(rx_buffer[i]);
    }
	// Set hardward registers
	// Look kern/e1000.h to find useful definations
	base->RCTL =0;
	base->RCTL |= E1000_RCTL_EN;
	base->RCTL |= E1000_RCTL_BSIZE_2048;  
	base->RCTL |= E1000_RCTL_SECRC;
	base->RDBAL = PADDR(rx_descs);
	base->RDBAH = 0;
	base->RDLEN = N_RXDESC* sizeof(struct rx_desc);
	base->RDH = 0;
	base->RDT = N_RXDESC-1;
	base->RAL = QEMU_MAC_LOW;
	base->RAH = QEMU_MAC_HIGH;

	return 0;


	// return 0;
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
	// // Send 'len' bytes in 'buf' to ethernet
	// // Hint: buf is a kernel virtual address
	// cprintf("in %s\n", __FUNCTION__);
	// if(tx_descs[base->TDT].status & E1000_TX_STATUS_DD){
	// 	tx_descs[base->TDT].status ^= E1000_TX_STATUS_DD;
	// 	memset(KADDR(tx_descs[base->TDT].addr), 0 , PKT_SIZE);
	// 	memcpy(KADDR(tx_descs[base->TDT].addr), buf, len);
	// 	tx_descs[base->TDT].length = len;
	// 	tx_descs[base->TDT].cmd |= E1000_TX_CMD_EOP|E1000_TX_CMD_RS;

	// 	base->TDT = (base->TDT + 1)%N_TXDESC;
	// }
	// else{
	// 	return -E_TX_FULL;
	// }
	// return 0;

	cprintf("in %s\n", __FUNCTION__);
	uint64_t tx_tail = read_tdt();
	if(len > MAX_PKT_SIZE){
		cprintf("dsafsfda\n");
		return -E_INVAL;
	}
	if(!check_dd_bit(&tx_descs[tx_tail])){
		return -E_AGAIN;
	}
	cprintf("tail index:%d\n", tx_tail);
	memset(transmit_packet_buffer[tx_tail], 0, MAX_PKT_SIZE);
	memmove(transmit_packet_buffer[tx_tail], buf, len);
	set_length(&tx_descs[tx_tail], len);
	set_rs_bit(&tx_descs[tx_tail]);
	set_eop_bit(&tx_descs[tx_tail]);
	clear_dd_bit(&tx_descs[tx_tail]);
	tx_tail = (tx_tail+1) % N_TXDESC;
	set_tdt(tx_tail);
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
	// cprintf("in %s\n", __FUNCTION__);
  	// uint32_t rdt = (base->RDT + 1) % N_RXDESC;

  	// if(!(rx_descs[rdt].status & E1000_RX_STATUS_DD)){
	// 	return -E_AGAIN;
	// }

  	// while(rdt == base->RDH);
	// assert(len > rx_descs[rdt].length);
  	// memcpy(buf, KADDR(rx_descs[rdt].addr), rx_descs[rdt].length);
  	// rx_descs[rdt].status ^= E1000_RX_STATUS_DD;

  	// base->RDT = rdt;
	// return len;


	// if(buf == NULL)
    // return -E_INVAL;
  	// uint32_t rdt = (base->RDT + 1) % N_RXDESC;
  	// if(!(rx_descs[rdt].status & E1000_RX_STATUS_DD))
    // 	return -E_AGAIN;

  	// while(rdt == base->RDH);
  	// uint32_t lenth = rx_descs[rdt].length;
  	// memmove(buf, rx_bufs[rdt], lenth);
  	// rx_descs[rdt].status &= ~E1000_RX_STATUS_DD;
	
  	// base->RDT = rdt;
	// return len;

	static uint32_t next =0;
	if(!(rx_descs[next].status & E1000_RX_STATUS_DD)) {	
					return -E_AGAIN;
	}
	if(rx_descs[next].error) {
					cprintf("[rx]error occours\n");
					return -E_UNSPECIFIED;
	}
	len = rx_descs[next].length;
	memmove(buf, rx_buffer[next], len);

	base->RDT = (base->RDT + 1) % N_RXDESC;
	next = (next + 1) % N_RXDESC;
	return len;

}
