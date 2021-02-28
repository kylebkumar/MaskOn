import torch
import torchvision
from torch.utils.mobile_optimizer import optimize_for_mobile

maskNet = torchvision.models.mobilenet_v2(pretrained=True)
maskNet.classifier[1] = torch.nn.Linear(1280, 2)

maskNet.load_state_dict(torch.load('mask_net.pt', map_location=torch.device('cpu')))



model = maskNet
model.eval()
example = torch.rand(1, 3, 224, 224)
traced_script_module = torch.jit.trace(model, example)
torchscript_model_optimized = optimize_for_mobile(traced_script_module)
torchscript_model_optimized.save("script_model.pt")