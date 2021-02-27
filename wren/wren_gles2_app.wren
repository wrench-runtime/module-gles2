import "wren_sdl2" for SdlApplication, SDL, SdlHint, SdlGlAttribute, SdlGlProfile, SdlWindowFlag, SdlGlContext
import "wren_gles2" for ClearFlag, GL, EnableCap, BlendFacDst, BlendFacSrc, ErrorCode

class Gles2Application is SdlApplication {

  glContext { _glCtx }

  construct new(){
    super()
  }

  sdlSetHints(){
    super.sdlSetHints()
    SDL.setHint(SdlHint.OpenglEsDriver, "1")
    SDL.setAttribute(SdlGlAttribute.ContextMajorVersion, 2)
    SDL.setAttribute(SdlGlAttribute.ContextMinorVersion, 0)
    SDL.setAttribute(SdlGlAttribute.ContextProfileMask, SdlGlProfile.Es)
    SDL.setAttribute(SdlGlAttribute.RedSize, 5)
    SDL.setAttribute(SdlGlAttribute.GreenSize, 6)
    SDL.setAttribute(SdlGlAttribute.BlueSize, 5)
    SDL.setAttribute(SdlGlAttribute.StencilSize, 1)
    sdlAddWindowFlag(SdlWindowFlag.Opengl)
  }

  sdlCreateWindow(){
    super.sdlCreateWindow()
    _glCtx = SdlGlContext.new(window)
    window.makeCurrent(_glCtx)
    SDL.setSwapInterval(1)
  }

  setVsync(v){
    if(v) {
      SDL.setSwapInterval(1)
    } else {
      SDL.setSwapInterval(0)
    }
  }

  checkErrors(){
    var err = GL.getError()
    if(err != ErrorCode.NO_ERROR){
        Fiber.abort("GL Error:" + ErrorCode.getString(err))
    }
  }
}