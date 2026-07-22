# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.4-base

# build-time tokens for gated downloads — never baked into final image.
# pass via: docker build --build-arg HF_TOKEN=$HF_TOKEN ...
ARG HF_TOKEN=""

# install custom nodes into comfyui
RUN git clone https://github.com/pixaroma/ComfyUI-Pixaroma /comfyui/custom_nodes/ComfyUI-Pixaroma && cd /comfyui/custom_nodes/ComfyUI-Pixaroma && (git checkout e99610041df9434f0694fa9d3319ad7743f01c88 2>/dev/null || (git fetch origin e99610041df9434f0694fa9d3319ad7743f01c88 --depth=1 && git checkout e99610041df9434f0694fa9d3319ad7743f01c88) || echo "WARN: commit e99610041df9434f0694fa9d3319ad7743f01c88 unreachable in https://github.com/pixaroma/ComfyUI-Pixaroma, falling back to default branch HEAD")
RUN git clone https://github.com/kijai/ComfyUI-KJNodes /comfyui/custom_nodes/ComfyUI-KJNodes && cd /comfyui/custom_nodes/ComfyUI-KJNodes && (git checkout 3581a89ef2035921b2566bffc12e70b78fd5fb7c 2>/dev/null || (git fetch origin 3581a89ef2035921b2566bffc12e70b78fd5fb7c --depth=1 && git checkout 3581a89ef2035921b2566bffc12e70b78fd5fb7c) || echo "WARN: commit 3581a89ef2035921b2566bffc12e70b78fd5fb7c unreachable in https://github.com/kijai/ComfyUI-KJNodes, falling back to default branch HEAD")
# RUN # Could not resolve custom node: PixaromaGetNode
# RUN # Could not resolve custom node: PixaromaSetNode

# download models into comfyui
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors' --relative-path models/clip_vision --filename 'clip_vision_h.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors' --relative-path models/text_encoders --filename 'umt5_xxl_fp8_e4m3fn_scaled.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/SCAIL-2/resolve/main/diffusion_models/wan2.1_14B_SCAIL_2_int8_convrot.safetensors?download=true' --relative-path models/diffusion_models --filename 'wan2.1_14B_SCAIL_2_int8_convrot.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/lightx2v/Wan2.1-I2V-14B-480P-StepDistill-CfgDistill-Lightx2v/resolve/main/loras/Wan21_I2V_14B_lightx2v_cfg_step_distill_lora_rank64.safetensors' --relative-path models/loras --filename 'Wan21_I2V_14B_lightx2v_cfg_step_distill_lora_rank64.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors' --relative-path models/vae --filename 'wan_2.1_vae.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
