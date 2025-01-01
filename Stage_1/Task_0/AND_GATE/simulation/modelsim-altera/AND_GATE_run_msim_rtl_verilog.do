transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/eyantra/Documents/Eyantra_Stage_1/Task_0/AND_GATE {/home/eyantra/Documents/Eyantra_Stage_1/Task_0/AND_GATE/and_gate.v}

vlog -vlog01compat -work work +incdir+/home/eyantra/Documents/Eyantra_Stage_1/Task_0/AND_GATE {/home/eyantra/Documents/Eyantra_Stage_1/Task_0/AND_GATE/and_gate_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  and_gate_tb

add wave *
view structure
view signals
run -all
