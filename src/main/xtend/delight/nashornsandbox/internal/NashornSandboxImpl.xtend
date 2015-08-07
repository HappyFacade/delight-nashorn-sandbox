package delight.nashornsandbox.internal

import delight.nashornsandbox.NashornSandbox
import java.util.HashSet
import java.util.Set
import javax.script.ScriptEngine
import jdk.nashorn.api.scripting.NashornScriptEngineFactory

class NashornSandboxImpl implements NashornSandbox {

	val Set<String> allowedClasses

	var ScriptEngine scriptEngine
	var Integer maxCPUTimeInMs = 0

	def void assertScriptEngine() {
		if (scriptEngine != null) {
			return
		}

		/*
		 * If eclipse shows an error here, see http://stackoverflow.com/a/10642163/270662
		 */
		val NashornScriptEngineFactory factory = new NashornScriptEngineFactory();

		scriptEngine = factory.getScriptEngine(new SandboxClassFilter(allowedClasses));
	}

	override Object eval(String js) {
		assertScriptEngine

		if (maxCPUTimeInMs == 0) {
			return scriptEngine.eval(js)
		}
		
		val MonitorThread monitorThread = new MonitorThread(maxCPUTimeInMs*1000, Thread.currentThread, [
			Thread.currentThread.interrupt
		])
		
		
		
	}

	override void allow(Class<?> clazz) {
		allowedClasses.add(clazz.name)
		scriptEngine = null
	}

	new() {
		this.allowedClasses = new HashSet()
	}

}