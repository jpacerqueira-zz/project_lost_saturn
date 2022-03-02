#
import subprocess
import shutil

def copy_raw_sh_to_local(source_sh , dest_local):
    raw_cv_folder='https://gft365.sharepoint.com/sites/DataCapability-Atlantic/Shared%20Documents/General/interviews/raw/external_source_cv_s&Folder'
    subprocess.call(r'net use Y: '+raw_cv_folder, shell=True)
    shutil.copy("Y:\\",dest_local)
    
def copy_local_to_raw_sh(source_local, dest_sh):
    raw_cv_folder='https://gft365.sharepoint.com/sites/DataCapability-Atlantic/Shared%20Documents/General/interviews/raw/external_source_cv_s&Folder'
    subprocess.call(r'net use Y: '+raw_cv_folder, shell=True)
    shutil.copy(source_local,"Y:\\")    
