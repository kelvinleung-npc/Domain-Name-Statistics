
use warnings; 
use strict;
use Time::Local;
# purpose of the program: Read in csv files from each server with date stamps and aggregate the domain 
# counts across servers into a daily count. adds new entries or changes values if there is a discrepancy of 
# on the domain count. Deletes files in folder afterwards




# Output: csv file in format of:
# By Date Server Count (this title is not present in file):
#     5 Apr 2022:_________:1232774
# By Date Domain over All Servers (this title is not present in file): 
#     5 Apr 2022:DOMAIN:9


sub output_date_server_domain_total_count {
    my %hash = %{$_[0]};                                            #####################################################
    for my $date ( keys %hash ){                                    # Takes in a hash of {date}{server}{domain} = count #
        for my $server ( keys %{$hash{$date}} ){                    # adds the total  together for all domains per      #
            my $total_count = 0;                                    # server. ex april 5th orthoclass: 100000000        #                                                   
            for my $domain ( keys %{$hash{$date}{$server}} ) {      #####################################################
                my $count = $hash{$date}{$server}{$domain};         
                $total_count = $total_count + $count;               
            }
            print "Server Data,$date,$server,$total_count\n";
        }
    }
}

sub output_date_domain_total_count {
    my %hash = %{$_[0]};                                          #########################################################
    for my $date ( keys %hash ){                                  # Takes the hash of {date}{domain} and outputs the      #
        for my $domain ( keys %{$hash{$date}} ) {                 # total count of the domain over all the servers        #
            my $count = $hash{$date}{$domain};                    # for that day ex april 5th BC.gov = 1000               #   
            print "Domain Data,$date:$domain:$count\n";           #########################################################
        }
    }
}

sub delete_files_from_folder {
    my $path = $_[0];
    opendir(DIR, $path) or die "Could not open $path\n";
    my @read_files;
                                                                ############################################################
    while (my $filename = readdir(DIR)) {                       # Given a file path, delete all the files from that folder.# 
        if($filename =~//){                                     # Cleans up folder so the new files can be uploaded at a   #
        push(@read_files, $filename);                           # later date.                                              #
        }                                                       ############################################################
    }

    chdir $path; 
    for my $file (@read_files){
        `rm $file`;
    }
    
}


sub generateEmail {
my $subject = "TEST";
my $body = shift;
my $user = "";                                                     ########################################################
my $contact = (--------------------------------------)[0];         # Using ____ send out an email to contact with subject #
                                                                   # and body paragraph                                   # 
                                                                   ########################################################

  #send email

    
}

sub convert_date {
    my $string = $_[0];
    my $day = '';
    my $month = '';
    my $year = ''; 
    my %mon2num = qw(
    Jan 0  Feb 1  Mar 2  Apr 3  May 4  Jun 5
    Jul 6  Aug 7  Sep 8  Oct 9 Nov 10 Dec 11
    );
    if($string =~ /(\S*)\s(\S*)\s(\S*)/){
        #print "$1 $2 $3";                         ###########################################################
        $day = $1;                                 # Turn string date into integer value based on epoch time #
        $month = $2;                               # this value will be as date value in AddEntry or SetEntry#  
        $year = $3;                                ###########################################################
        if(length($day) eq 1){
            $day = '0'.$day; 
        }
        if(exists($mon2num{$month})){
            $month = $mon2num{$month};
        }
        else{
            printf STDERR "%s: date value passed into convert_date not in string form of day month year ex:5 apr 2022 \n",scalar(localtime);
        }
    }
    $year = $year - 1900; 
    return timelocal(0,0,0,$day,$month,$year); 
}

sub add_update_record_date_domain_total_count {
    my %files_hash = %{$_[0]};
    my @____________;
    my $header1 = "<h3>New Entries</h3>";                                                                    ###############################################
    my $header2 = "<h3>Updated Entries</h3>";                                                                # start of tables to send via email of        #
    my $body1 = "<table border=\"1\"><tr><th>Date</th><th>Domain</th><th>Count</th></tr>";                   # new entries and updates                     #
    my $body2 = "<table border=\"1\"><tr><th>Date</th><th>Domain</th><th>Count</th><th>EntryID</th></tr>";   ###############################################

    for my $date (keys %files_hash){ 
        my $DATE = convert_date($date);
        my @records = ____________________________________;
        @______________ = (@______________,@records);
    }
                                                                                ######################################################
    my %log_hash;                                                               # Build a hash out of all _________________ records  #
    for my $log (@_________________){                                           # of dates provided to see if the record exists      #
        my @log = @{$log};                                                      ######################################################
        $log_hash{$log->[0]}{$log->[1]} = [@log];                               
    }
    for my $date ( keys %files_hash ){
        my $DATE = convert_date($date);
        for my $domain ( keys %{$files_hash{$date}} ) {
            my $count = $files_hash{$date}{$domain};
                                                                                   #################################################################
            if(exists($log_hash{$DATE}{$domain})){                                 # If record exists, if the count is different change the count. #
                                                                                   # If no entry exists, create a new entry of it.                 #
                my @record_data = @{$log_hash{$DATE}{$domain}};                    # This allows for rerunning of files incase of server issues    #
                if ($count != $record_data[2]){                                    #################################################################
                        
                        # SET DATA BASE ENTRY #

                    $body2 = $body2."<tr><th>".$DATE."</th><th>".$domain."</th><th>".$count."</th><th>".$record_data[3]."</th></tr>"; 
                } 
            }
            else{
            
                    #ADD ENTRY 

            }
        }
    }
    $body1 = $body1."</table>";
    $body2 = $body2."</table>";
    my $emailbody = $header1.$body1.$header2.$body2; 
    generateEmail($emailbody);
}


### MAIN ### 


my @Domains = ___________________________;

my %hash_of_days; 
my $DNSStatDirectory = '';
printf STDERR "%s: Starting Domain Name Statistics \n",scalar(localtime);
opendir(DIR, $DNSStatDirectory) or die "Could not open $DNSStatDirectory\n";
#grab all file names 
my %DNS_CSV_FILES;  
my @read_files; 
while (my $filename = readdir(DIR)) {
    if ($filename =~ /\.([^\.]+)\.csv$/){
        my $DATE = $1;                                     ############################################# 
        if($DATE =~ /([a-zA-Z]{3})(\d+)(\d{4})/){          # Read in all files from Directory and      # 
            $DATE ="$2 $1 $3";                             # change their date to better formatting    #                                              
            $hash_of_days{$DATE} = 'exists';               # then place them into a array inside a hash# 
            if(exists($DNS_CSV_FILES{$DATE})){             # by their date.                            # 
                my $array = $DNS_CSV_FILES{$DATE};         #############################################

                push(@$array,$filename);
            }
            else{
                $DNS_CSV_FILES{$DATE} = [$filename];
            }
            push(@read_files, $filename);    
        }   
        else{
            printf STDERR "%s: csv $filename does not have a correctly formatted date section \n",scalar(localtime);    
        }

    }
}
printf STDERR "%s: csv files successfully read in @read_files \n",scalar(localtime);

my %Date_Domain_Hash; 
for my $date (keys %hash_of_days){                 
    my $DATE = $date;                              ###############################################
    if($date =~ /([a-zA-Z]{3})(\d+)(\d{4})/){      # Intialize the hash of Domains by date count #
        $DATE ="$2 $1 $3";                         ###############################################
    }                                              
    for my $domain(@Domains){                          
        $Date_Domain_Hash{$DATE}{$domain} = 0;
    }
}

my %Date_Server_Domain_Hash_Count;
for my $key ( keys %DNS_CSV_FILES){
    for my $file (@{$DNS_CSV_FILES{$key}}){
        my $servername = '';
        if($file =~ /^([A-Za-z]*\.)/){
            $servername = $1; 
        }
        open(FH,'<', $DNSStatDirectory.'/'.$file) or die "could not open $file";
        my $line_count = 0; 
        while(<FH>){                                                                           #############################################################
            if ($_ =~ /^(\d+\s[A-Za-z]{3}\s\d{4}),(\d+),(.*),*/){                              # read files in from DNS_CSV_FILES by date line by line     #
                my $date = $1;                                                                 # and add count to matching domain in for both server count #
                my $count = $2;                                                                # and overall domain count                                  #
                my $domain = $3;                                                               #############################################################
                while( ( ( my $host, $domain ) = ( $domain =~ /^([^\.]+)\.(.*)$/) )){
                    if( exists($Date_Domain_Hash{$date}{$domain}) ){
                        $Date_Domain_Hash{$date}{$domain} = $Date_Domain_Hash{$date}{$domain} + $count;
                        if( exists($Date_Server_Domain_Hash_Count{$date}{$servername}{$domain}) ){
                            $Date_Server_Domain_Hash_Count{$date}{$servername}{$domain} = $Date_Server_Domain_Hash_Count{$date}{$servername}{$domain} + $count;
                        }
                        else{
                            $Date_Server_Domain_Hash_Count{$date}{$servername}{$domain} = $count; 
                        }
                        last;     
                    }
                } 
            }
            $line_count++; 
        }
        printf STDERR "%s: $servername has a line count of $line_count \n",scalar(localtime);
    }
}


add_update_record_date_domain_total_count(\%Date_Domain_Hash);
delete_files_from_folder($DNSStatDirectory);
output_date_server_domain_total_count(\%Date_Server_Domain_Hash_Count);
output_date_domain_total_count(\%Date_Domain_Hash);
