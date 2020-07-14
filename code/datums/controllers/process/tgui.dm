/**
 * Copyright (c) 2020 Aleksej Komarov & ZeWaka
 * SPDX-License-Identifier: MIT
 */

var/global/datum/controller/process/tgui/tgui_process

// handles tgui interfaces
/datum/controller/process/tgui
	var/list/currentrun = list()
	var/list/open_uis = list() // A list of open UIs, grouped by src_object and ui_key.
	var/list/processing_uis = list() // A list of processing UIs, ungrouped.
	var/basehtml // The HTML base used for all UIs.

	setup()
		name = "tgui"
		schedule_interval = 9 DECI SECONDS
		basehtml = file2text('tgui/packages/tgui/public/tgui.html')
		tgui_process = src

	doWork()
		src.currentrun = processing_uis.Copy()
		//cache for sanic speed (lists are references anyways)
		var/list/currentrun = src.currentrun

		while(currentrun.len)
			var/datum/tgui/ui = currentrun[currentrun.len]
			currentrun.len--
			if(ui && ui.user && ui.src_object)
				ui.process()
			else
				processing_uis.Remove(ui)
			scheck()

	onKill()
		close_all_uis()

	tickDetail()
		boutput(usr, "P:[processing_uis.len]")
