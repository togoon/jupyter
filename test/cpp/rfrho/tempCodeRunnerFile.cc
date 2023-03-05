	time_t nowtime;
	struct tm* p;;
	time(&nowtime);
	p = localtime(&nowtime);
	printf("%02d:%02d:%02d\n",p->tm_hour,p->tm_min,p->tm_sec);