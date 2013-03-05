#include <hx/Macros.h>
#include <hx/CFFI.h>
#include <hxcpp.h>

#include "NMEWebView.h"
	
using namespace arcademonk;

#ifdef HX_WINDOWS
	typedef wchar_t OSChar;
	#define val_os_string val_wstring
#else
	typedef char OSChar;
	#define val_os_string val_string
#endif

extern "C" {
    void nme_extensions_main(){
        printf("nme_extensions_main()\n");
    }
    //DEFINE_ENTRY_POINT(nme_extensions_main)

    int nmewebview_register_prims(){
        printf("nmewebview: register_prims()\n");
        nme_extensions_main();
        return 0;
    }
}

#ifdef IPHONE
    void webviewAPIInit (value _onDestroyedCallback, value _onURLChangingCallback, value withPopup) { init(_onDestroyedCallback, _onURLChangingCallback, val_bool(withPopup)); }
	DEFINE_PRIM (webviewAPIInit, 3);
	
	void webviewAPINavigate (value url) { navigate(val_string(url)); }
	DEFINE_PRIM (webviewAPINavigate, 1);
	
	void webviewAPIDestroy(){ destroy(); }
	DEFINE_PRIM (webviewAPIDestroy, 0);
#endif
