#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdbool.h>
#include <wren.h>
#include <wren_runtime.h>
#include <GLES2/gl2.h>

static void wren_runtime_error(WrenVM* vm, const char * error){
  wrenSetSlotString(vm, 0, error); 
  wrenAbortFiber(vm, 0);
}

#define REP0
#define REP1 "_"
#define REP2 REP1 ",_"
#define REP3 REP2 ",_"
#define REP4 REP3 ",_"
#define REP5 REP4 ",_"
#define REP6 REP5 ",_"
#define REP7 REP6 ",_"
#define REP8 REP7 ",_"
#define REP9 REP8 ",_"
#define REP10 REP9 ",_"
#define REP11 REP10 ",_"
#define ARGS(TIMES) "(" REP##TIMES ")"

#define GetEnum(i) (GLenum)wrenGetSlotDouble(vm, i)
#define GetIntptr(i) (GLintptr)wrenGetSlotDouble(vm, i)
#define GetInt(i) (GLint)wrenGetSlotDouble(vm, i)
#define GetFloat(i) (GLfloat)wrenGetSlotDouble(vm, i)
#define GetUint(i) (GLuint)wrenGetSlotDouble(vm, i)
#define GetGlHandle(i) (GLuint)wrenGetSlotType(vm, i) != WREN_TYPE_NULL ? *(GLuint*)wrenGetSlotForeign(vm, i) : 0
#define GetClampf(i) (GLclampf)wrenGetSlotDouble(vm, i)
#define GetBitfield(i) (GLbitfield)wrenGetSlotDouble(vm, i)
#define GetInt(i) (GLint)wrenGetSlotDouble(vm, i)
#define GetSizei(i) (GLsizei)wrenGetSlotDouble(vm, i)
#define GetSizeiptr(i) (GLsizeiptr)wrenGetSlotDouble(vm, i)
#define GetStringLen(i,len) (const GLchar*)wrenGetSlotBytes(vm, i, &len)
#define GetString(i) (const GLchar*)wrenGetSlotString(vm, i)
#define GetBool(i) (GLboolean)wrenGetSlotBool(vm, i)

#define ReturnDouble(v) wrenSetSlotDouble(vm, 0, v)
#define ReturnStr(v) wrenSetSlotString(vm, 0, v)
#define ReturnNull() wrenSetSlotNull(vm, 0)
#define ReturnForeign(class) (GLuint*)wrenSetSlotNewForeign(vm, 0, class, sizeof(GLuint))

#define DefMethod(name, args) static void wren_gles2_GL_##name##_##args(WrenVM* vm)
#define BindMethod(name, args) wrt_bind_method("wren_gles2.GL." #name ARGS(args) , wren_gles2_GL_##name##_##args)
#define DefClass(name, destruct) static void wren_gles2_##name##_allocate(WrenVM* vm){\
  wrenSetSlotNewForeign(vm, 0, 0, sizeof(GLuint));\
}\
static void wren_gles2_##name##_destroy(void* data){\
  GLuint handle = *(GLuint*)data;\
  if(handle == 0) { return; }\
  destruct;\
  *((GLuint*)data) = 0;\
}
#define BindClass(name) wrt_bind_class("wren_gles2." #name, wren_gles2_##name##_allocate, wren_gles2_##name##_destroy)
#define DestructClass(name, i) wren_gles2_##name##_destroy((void*)wrenGetSlotForeign(vm, i))


DefClass(GlBuffer, glDeleteBuffers(1, &handle))
DefClass(GlShader, glDeleteShader(handle))
DefClass(GlProgram, glDeleteProgram(handle))
DefClass(GlTexture, glDeleteTextures(1, &handle))

int plugin_handle;

typedef struct {
  size_t size;
  char* data;
} Buffer;

static inline void* get_buffer_ptr(WrenVM* vm, int slot, size_t offset, size_t size){
  if(wrenGetSlotType(vm, slot) == WREN_TYPE_NULL) return NULL;
  Buffer buffer = *(Buffer*)wrenGetSlotForeign(vm, slot);
  if((offset + size) > buffer.size){
    wren_runtime_error(vm, "Buffer out of bounds");
    return NULL;
  }
  return (void*)&buffer.data[offset];
}
#define GetVoid(i, offset, size) (GLvoid*)get_buffer_ptr(vm, i, offset, size)


DefMethod(clear, 1){
  glClear(GetBitfield(1));
}

DefMethod(clearColor, 4){
  glClearColor(GetClampf(1),GetClampf(2),GetClampf(3),GetClampf(4));
}

DefMethod(enable, 1){
  glEnable(GetEnum(1));
}

DefMethod(disable, 1){
  glDisable(GetEnum(1));
}

DefMethod(blendFunc, 2){
  glBlendFunc(GetEnum(1), GetEnum(2));
}

DefMethod(getError, 0){
  ReturnDouble(glGetError());
}

DefMethod(viewport, 4){
  glViewport(GetInt(1),GetInt(2),GetSizei(3),GetSizei(4));
}

DefMethod(createBuffer, 1){
  GLuint* buffer = ReturnForeign(1);
  glGenBuffers(1, buffer);
}

DefMethod(bindBuffer, 2){
  glBindBuffer(GetEnum(1), GetGlHandle(2));
}

DefMethod(bufferData, 5){
  GLvoid* ptr = GetVoid(2, GetSizeiptr(3), GetSizeiptr(4));
  glBufferData(GetEnum(1), GetSizeiptr(4), ptr, GetEnum(5));
}

DefMethod(bufferSubData, 6){
  GLvoid* ptr = GetVoid(4, GetSizeiptr(5), GetSizeiptr(6));
  glBufferSubData(GetEnum(1), GetIntptr(2), GetSizeiptr(3), ptr);
}

DefMethod(createShader, 2){
  GLuint* shader = ReturnForeign(2);
  *shader = glCreateShader(GetEnum(1));
}

DefMethod(shaderSource, 2){
  int len; 
  const GLchar* str = GetStringLen(2, len);
  glShaderSource(GetGlHandle(1), 1, &str, &len);
}

DefMethod(compileShader, 1){
  glCompileShader(GetGlHandle(1));
}

DefMethod(getShaderParameter, 2){
  GLint val;
  glGetShaderiv(GetGlHandle(1), GetEnum(2), &val);
  ReturnDouble(val);
}

DefMethod(getShaderInfoLog, 1){
  GLint length;
  glGetShaderiv(GetGlHandle(1), GL_INFO_LOG_LENGTH, &length);
  if(length == 0) {
    ReturnNull();
    return;
  }
  GLchar* buffer = (GLchar*)malloc((size_t)length);
  glGetShaderInfoLog(GetGlHandle(1), (GLsizei)length, (GLsizei*)&length, buffer);
  ReturnStr(buffer);
  free(buffer);
}

DefMethod(deleteShader, 1){
  DestructClass(GlShader, 1);
}

DefMethod(createProgram, 1){
  GLuint* ptr = ReturnForeign(1);
  *ptr = glCreateProgram();
}

DefMethod(attachShader, 2){
  glAttachShader(GetGlHandle(1), GetGlHandle(2));
}

DefMethod(linkProgram, 1){
  glLinkProgram(GetGlHandle(1));
}

DefMethod(useProgram, 1){
  glUseProgram(GetGlHandle(1));
}

DefMethod(getProgramParameter, 2){
  GLint value;
  glGetProgramiv(GetGlHandle(1), GetEnum(2), &value);
  ReturnDouble(value);
}

DefMethod(getProgramInfoLog, 1){
  GLint length;
  glGetProgramiv(GetGlHandle(1), GL_INFO_LOG_LENGTH, &length);
  if(length == 0) {
    ReturnNull();
    return;
  }
  GLchar* buffer = (GLchar*)malloc((size_t)length);
  glGetProgramInfoLog(GetGlHandle(1), (GLsizei)length, (GLsizei*)&length, buffer);
  ReturnStr(buffer);
  free(buffer); 
}

DefMethod(deleteProgram, 1){
  DestructClass(GlProgram, 1);
}

DefMethod(getAttribLocation, 2){
  ReturnDouble(glGetAttribLocation(GetGlHandle(1), GetString(2)));
}

DefMethod(vertexAttribPointer, 6){
  glVertexAttribPointer(GetUint(1), GetInt(2), GetEnum(3), GetBool(4), GetSizei(5), (const GLvoid*)GetSizei(6));
}

DefMethod(enableVertexAttribArray, 1){
  glEnableVertexAttribArray(GetUint(1));
}

DefMethod(getUniformLocation, 2){
  ReturnDouble(glGetUniformLocation(GetGlHandle(1), GetString(2)));
}

DefMethod(uniform1i, 2){
  glUniform1i(GetInt(1), GetInt(2));
}

DefMethod(uniform2i, 3){
  glUniform2i(GetInt(1), GetInt(2), GetInt(3));
}

DefMethod(uniform3i, 4){
  glUniform3i(GetInt(1), GetInt(2), GetInt(3), GetInt(4));
}

DefMethod(uniform4i, 5){
  glUniform4i(GetInt(1), GetInt(2), GetInt(3), GetInt(4), GetInt(5));
}

DefMethod(uniform1f, 2){
  glUniform1f(GetInt(1), GetFloat(2));
}

DefMethod(uniform2f, 3){
  glUniform2f(GetInt(1), GetFloat(2), GetFloat(3));
}

DefMethod(uniform3f, 4){
  glUniform3f(GetInt(1), GetFloat(2), GetFloat(3), GetFloat(4));
}

DefMethod(uniform4f, 5){
  glUniform4f(GetInt(1), GetFloat(2), GetFloat(3), GetFloat(4), GetFloat(5));
}

DefMethod(drawElements, 4){
  glDrawElements(GetEnum(1), GetSizei(2), GetEnum(3), (const GLvoid*)GetSizei(4));
}

DefMethod(createTexture, 1){
  GLuint* texture = ReturnForeign(1);
  glGenTextures(1, texture);
}

DefMethod(bindTexture, 2){
  glBindTexture(GetEnum(1), GetGlHandle(2));
}

DefMethod(texImage2D, 11){
  GLvoid* data = GetVoid(9, GetSizeiptr(10), GetSizeiptr(11));
  glTexImage2D(GetEnum(1), GetInt(2), GetInt(3), GetSizei(4), GetSizei(5), GetInt(6), GetEnum(7), GetEnum(8), data);
}


DefMethod(texSubImage2D, 11){
  GLvoid* data = GetVoid(9, GetSizeiptr(10), GetSizeiptr(11));
  glTexSubImage2D(GetEnum(1), GetInt(2), GetInt(3), GetInt(4), GetSizei(5), GetSizei(6), GetEnum(7), GetEnum(8), data);
}

DefMethod(generateMipmap, 1){
  glGenerateMipmap(GetEnum(1));
}

DefMethod(texParameteri, 3){
  glTexParameteri(GetEnum(1), GetEnum(2), GetEnum(3));
}

DefMethod(activeTexture, 1){
  glActiveTexture(GetEnum(1));
}

DefMethod(createFramebuffer, 1){
  GLuint* fb = ReturnForeign(1);
  glGenFramebuffers(1, fb);
}

DefMethod(bindFramebuffer, 2){
  glBindFramebuffer(GetEnum(1), GetGlHandle(2));
}

DefMethod(framebufferTexture2D, 5){
  glFramebufferTexture2D(GetEnum(1), GetEnum(2), GetEnum(3), GetGlHandle(4), GetInt(5));
}

DefMethod(checkFramebufferStatus, 1){
  ReturnDouble(glCheckFramebufferStatus(GetEnum(1)));
}

WrenForeignMethodFn wrt_plugin_init_wren_gles2(int handle){
  plugin_handle = handle;

  BindClass(GlShader);
  BindClass(GlProgram);
  BindClass(GlBuffer);
  BindClass(GlTexture);

  BindMethod(clear, 1);
  BindMethod(clearColor, 4);
  BindMethod(enable, 1);
  BindMethod(disable, 1);
  BindMethod(blendFunc, 2);
  BindMethod(getError, 0);
  BindMethod(viewport, 4);
  BindMethod(createBuffer, 1);
  BindMethod(bindBuffer, 2);
  BindMethod(bufferData, 5);
  BindMethod(bufferSubData, 6);
  BindMethod(createShader, 2);
  BindMethod(shaderSource, 2);
  BindMethod(compileShader, 1);
  BindMethod(getShaderParameter, 2);
  BindMethod(getShaderInfoLog, 1);
  BindMethod(deleteShader, 1);
  BindMethod(createProgram, 1);
  BindMethod(attachShader, 2);
  BindMethod(linkProgram, 1);
  BindMethod(useProgram, 1);
  BindMethod(getProgramParameter, 2);
  BindMethod(getProgramInfoLog, 1);
  BindMethod(deleteProgram, 1);
  BindMethod(getAttribLocation, 2);
  BindMethod(vertexAttribPointer, 6);
  BindMethod(enableVertexAttribArray, 1);
  BindMethod(getUniformLocation, 2);
  BindMethod(uniform1i, 2);
  BindMethod(uniform2i, 3);
  BindMethod(uniform3i, 4);
  BindMethod(uniform4i, 5);
  BindMethod(uniform1f, 2);
  BindMethod(uniform2f, 3);
  BindMethod(uniform3f, 4);
  BindMethod(uniform4f, 5);
  BindMethod(drawElements, 4);
  BindMethod(createTexture, 1);
  BindMethod(bindTexture, 2);
  BindMethod(texImage2D, 11);
  BindMethod(texSubImage2D, 11);
  BindMethod(generateMipmap, 1);
  BindMethod(texParameteri, 3);
  BindMethod(activeTexture, 1);
  BindMethod(createFramebuffer, 1);
  BindMethod(bindFramebuffer, 2);
  BindMethod(framebufferTexture2D, 5);
  BindMethod(checkFramebufferStatus, 1);

  return NULL;
}
