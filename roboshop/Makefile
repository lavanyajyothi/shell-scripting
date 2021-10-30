help:
	 @IFS=$$'\n' ; \
        help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
        for help_line in $${help_lines[@]}; do \
            IFS=$$'#' ; \
            help_split=($$help_line) ; \
            help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
            help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
            printf "%-15s %s\n" $$help_command $$help_info ; \
        done
git-pull:
	@echo ---------+ Pulling Git Code +......
	@git pull &>/dev/null
cart:git-pull ## setup cart component
	@sudo bash components/cart.sh

catalogue:git-pull ## setup catalogue component
	@sudo bash components/catalogue.sh

user:git-pull ## setup user component
	@sudo bash components/user.sh

shipping:git-pull  ## setup shipping component
	@sudo bash components/shipping.sh

payment:git-pull ## setup payment component
	@sudo bash components/payment.sh

frontend:git-pull ## setup frontend component
	@sudo bash components/frontend.sh

mysql:git-pull ## setup mysql component
	@sudo bash components/mysql.sh

redis:git-pull ## setup reddis component
	@sudo bash components/reddis.sh

rabbitmq:git-pull ## setup rabbitmq component
	@sudo bash components/rabbitmq.sh

mongodb:git-pull ## setup mongodb component
	@sudo bash components/mongodb.sh




