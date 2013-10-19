// To compile:
// 	dfl dlltest dlltest.def

// To use this from an exe, use LoadLibraryA() with the DLL's file name, or use an import lib.


private import dfl.all, dfl.internal.winapi;


private extern(C)
{
	void gc_init();
	void gc_term();
	void _minit();
	void _moduleCtor();
	//void _moduleUnitTests();
}


extern(Windows) BOOL DllMain(HINSTANCE hInstance, ULONG ulReason, LPVOID pvReserved)
{
	switch(ulReason)
	{
		case DLL_PROCESS_ATTACH:
			gc_init(); // Initialize GC.
			_minit(); // Initialize module list.
			Application.setInstance(hInstance); // Before user code but after initializing D.
			_moduleCtor(); // Run module constructors.
			//_moduleUnitTests(); // Run module unit tests.
			
			with(new Form)
			{
				text = "Form from DLL!";
				show();
			}
			// No Application.run() because the exe takes care of that.
			break;
		
		case DLL_PROCESS_DETACH:
			gc_term(); // Shut down GC.
			break;
		
		case DLL_THREAD_ATTACH:
		case DLL_THREAD_DETACH:
			return false; // No multiple threads.
		
		default: ;
	}
	return true;
}

