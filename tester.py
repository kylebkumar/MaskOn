import torch
import torch.nn as nn
import torchvision
from torchvision import transforms, datasets
import os
import numpy as np
import ssl
import sys
from PIL import Image
from PIL import ImageFile
ImageFile.LOAD_TRUNCATED_IMAGES = True

use_cuda = torch.cuda.is_available()

data_dir = './dataset'

transform = transforms.Compose([transforms.Resize(225), transforms.CenterCrop(224), transforms.ToTensor(),                                                    transforms.Normalize(mean = [0.485, 0.456, 0.406], std = [0.229, 0.224, 0.225])])

data = datasets.ImageFolder(data_dir, transform=transform)

maskNet = torchvision.models.mobilenet_v2(pretrained=True)
maskNet.classifier[1] = torch.nn.Linear(1280, 2)

maskNet.load_state_dict(torch.load('mask_net.pt', map_location=torch.device('cpu')))


img = Image.open("./dataset/without_mask/mask_off6.jpg")

transformer = transforms.Compose([transforms.Resize(256), transforms.CenterCrop(224), transforms.ToTensor(),
                                      transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])])

img = transformer(img)

img = img.unsqueeze(0)
print(data.classes)
maskNet.eval()
# new_model = torch.jit.load("script_model.pt")
def get_prediction(img_path):
    img = Image.open(img_path)

    transformer = transforms.Compose([transforms.Resize(256), transforms.CenterCrop(224), transforms.ToTensor(),
                                      transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])])

    img = transformer(img)




    img = img.unsqueeze(0)
    ## Return the *index* of the predicted class for that image

    int_output = int(maskNet.forward(img).cpu().detach().numpy().argmax())


    classes = ["without_mask", "with_mask"]

    return (data.classes[int(int_output)])

print(data.classes)
correct = 0
ii = 0
limit = 1000
error_list = ''
for filename in os.listdir('dataset/without_mask'):
    if filename[0] != '.':
        try:
            prediction = get_prediction('dataset/without_mask/' + filename)
            if(prediction == 'without_mask'):
                correct +=1
            ii += 1

        except Exception:
            img = Image.open('dataset/without_mask/' + filename)

            error_list += filename + ' has invalid size ' + str(img.size) + 'and it caused an error. It will be deleted' + '\n'

print("Accuracy: " + str(correct/ii))
print(error_list)
