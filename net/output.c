#include "ns.h"

extern union Nsipc nsipcbuf;

void
sleep(int sec)
{
	unsigned now = sys_time_msec();
	unsigned end = now + sec * 1000;

	if ((int)now < 0 && (int)now > -MAXERROR)
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
		panic("sleep: wrap");

	while (sys_time_msec() < end)
		sys_yield();
}

void
output(envid_t ns_envid)
{
	// cprintf("in %s\n", __FUNCTION__);
	// binaryname = "ns_output";

	// // LAB 6: Your code here:
	// // 	- read a packet request (using ipc_recv)
	// //	- send the packet to the device driver (using sys_net_send)
	// //	do the above things in a loop
	// envid_t from_env_store;
	// int perm_store; 

	// int r;
	// while(1){
	// 	r = ipc_recv(&from_env_store, &nsipcbuf, &perm_store);
	// 	if(r < 0)
	// 		panic("ipc_recv panic\n");
	// 	while((r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0){
	// 		if(r != -E_TX_FULL)
	// 			panic("sys_net_send panic\n");
	// 	}
	// }
	// cprintf("return in output\n");


binaryname = "ns_output";

	// LAB 6: Your code here:
	// 	- read a packet request (using ipc_recv)
	//	- send the packet to the device driver (using sys_net_send)
	//	do the above things in a loop
	while(1){
		envid_t env;
		int r;
		cprintf("%d: %s before ipc_recv\n", thisenv->env_id, __FUNCTION__);
		if((r = ipc_recv(&env, &nsipcbuf, NULL)) < 0){
			panic("ipc_recv:%d", r);
		}
		cprintf("%d: %s after ipc_recv\n", thisenv->env_id, __FUNCTION__);
		cprintf("%d: %s before sys_net_send\n", thisenv->env_id, __FUNCTION__);
		r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
		cprintf("%d: %s after sys_net_send\n", thisenv->env_id, __FUNCTION__);
		while(r == -E_AGAIN){
			cprintf("again!\n");
			sleep(2);
			// sys_yield();
			r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
		}
		if(r < 0){
			panic("sys_net_send:%d", r);
		}
	}
}
