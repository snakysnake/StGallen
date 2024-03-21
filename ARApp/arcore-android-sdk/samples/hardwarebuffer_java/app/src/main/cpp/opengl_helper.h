/*
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef C_ARCORE_HELLOE_AR_OPENGL_HELPER_H_
#define C_ARCORE_HELLOE_AR_OPENGL_HELPER_H_

#define EGL_EGLEXT_PROTOTYPES

#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>
#include <android/asset_manager.h>
#include <jni.h>

#include <memory>
#include <set>
#include <string>
#include <unordered_map>

#include "util.h"

namespace hello_ar {

// OpenGl Helper handles some OpenGl operations.
class OpenGlHelper {
 public:
  // Constructor and deconstructor.
  explicit OpenGlHelper();
  ~OpenGlHelper();

  // Create a egl image based on provided hardware buffer.
  //
  // @param buffer, the hardware buffer.
  EGLImageKHR CreateEglImage(AHardwareBuffer* buffer);

  // Destroy the provided Egl image.
  //
  // @param image, the Egl image.
  void DestroyEglImage(EGLImageKHR image);

  // Bind the Egl image to the external OES texture.
  //
  // @param image, the Egl image.
  // @param texture_oes_id, id of the external OES texture.
  void BindEglImageToTexture(EGLImageKHR image, uint32_t texture_oes_id);
};
}  // namespace hello_ar

#endif  // C_ARCORE_HELLOE_AR_OPENGL_HELPER_H_
