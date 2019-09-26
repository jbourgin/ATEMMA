import os
import shutil
from datetime import datetime

path_analysis = '/media/jessica/SSD_DATA/'
path = os.path.join(path_analysis,'IRM_Gaze', 'Files_ready')
path_volbrain = os.path.join(path_analysis, 'Volbrain_mri')
volbrain_folders = [name for name in os.listdir(path_volbrain) if os.path.isdir(os.path.join(path_volbrain, name)) and len(name) > 2]

def read_header(csv_file):
    new_dic = {}
    with open(csv_file, "r") as file:
        data = file.readline().replace('\n','')
        for count, elt in enumerate(data.split(';')):
            new_dic[elt] = count
    def f(line, column_name):
        return line[new_dic[column_name]]
    return f

def open_file(csv_file):
    get_element = read_header(csv_file)
    with open(csv_file, "r") as file:
        data = file.read()
        line_list = data.split('\n')
        final_data = [x.split(';') for x in line_list]
        headers = final_data[0]
        final_data = final_data[1:]
        final_data = [x for x in final_data if len(x) > 1]
        return (final_data, get_element, headers)

os.chdir(path)

(ppt_information, get_element, headers) = open_file("final_subjects_resting.csv")

data_merged = open("final_subjects_resting_scores.csv", "w")
titlestoadd = ['Tissue_IC', 'Amygdala_left', 'Amygdala_right', 'Normalized Amygdala_left','Normalized Amygdala_right', 'Normalized Amygdala']
for elt in titlestoadd:
    headers.append(elt)
headers = ";".join(headers) + "\n"
data_merged.write(headers)

def get_normalized_elt(elt, ICV):
    return float(elt)/float(ICV)*100

def get_all_vol_values(elt, csvline):
    elt_list = []
    elt_list.append(get_elt_col(csvline[0], '%s Left cm3'%elt))
    elt_list.append(get_elt_col(csvline[0], '%s Right cm3'%elt))
    elt_list.append(get_normalized_elt(elt_list[0], ICV))
    elt_list.append(get_normalized_elt(elt_list[1], ICV))
    elt_list.append(elt_list[2]+elt_list[3])
    return elt_list

for line in ppt_information:
    id = get_element(line, 'Sujets')
    print(id)
    elementstoadd = None
    for folder in volbrain_folders:
        if folder.startswith('%s'%id):
            print(folder)
            filenames = [name for name in os.listdir(os.path.join(path_volbrain, folder)) if '.csv' in name]
            csvfile = filenames[0]
            print(csvfile)
            (csvline, get_elt_col, headersvol) = open_file(os.path.join(path_volbrain, folder, csvfile))
            ICV = get_elt_col(csvline[0], 'Tissue IC cm3')

            amy_list = get_all_vol_values('Amygdala', csvline)

            elementstoadd = [ICV, amy_list[0], amy_list[1], amy_list[2], amy_list[3], amy_list[4]]
            new_line = line
            for elt in elementstoadd:
                new_line.append(elt)
            new_line = [str(x).replace('*','').replace('None','NaN') for x in new_line]
            new_line = ";".join(new_line) + "\n"
            data_merged.write(new_line)
            break

data_merged.close()
