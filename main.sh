#!/bin/bash

# Run the command with a timeout of 10 seconds
timeout 10s tshark -i wlp2s0 -w capture.pcap

pcap_file=./capture.pcap

# Function to analyze the network traffic and generate the report
analyze_traffic() {

    total_packets=$(tshark -r "$pcap_file" | wc -l)
    http_packets=$(tshark -r "$pcap_file" -Y "http" | wc -l)
    https_packets=$(tshark -r "$pcap_file" -Y "ssl" | wc -l)
    top_source_ips=$(tshark -r "$pcap_file" -T fields -e ip.src | sort | uniq -c | sort -nr | head -n 5)
    top_dest_ips=$(tshark -r "$pcap_file" -T fields -e ip.dst | sort | uniq -c | sort -nr | head -n 5)

}
analyze_traffic

touch report.txt
    # Output the analysis report
    echo "---- Network Traffic Analysis Report ----" > report.txt
    echo "1. Total Packets: $total_packets" >> report.txt 
    echo "" >> report.txt
    echo "2. Protocols:" >> report.txt
    echo "   - HTTP: $http_packets packets" >> report.txt
    echo "   - HTTPS/TLS: $https_packets packets" >> report.txt
    echo "" >> report.txt
    echo "3. Top 5 Source IP Addresses:" >> report.txt
    echo "$top_source_ips" | awk '{print "   -", $2 ": " $1 " packets"}' >> report.txt
    echo "" >> report.txt
    echo "4. Top 5 Destination IP Addresses:" >> report.txt
    echo "$top_dest_ips" | awk '{print "   -", $2 ": " $1 " packets"}' >> report.txt
    echo "" >>report.txt
    echo "----- End of Report -----" >> report.txt

    cat report.txt


