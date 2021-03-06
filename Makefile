# Makefile for check_raid plugin
PLUGIN          := check_raid
PLUGIN_SCRIPT   := $(PLUGIN).pl
PLUGIN_VERSION  := $(shell awk -F'"' '/VERSION/&&/=/{print $$2}' $(PLUGIN_SCRIPT))
PLUGINDIR       := /usr/lib/nagios/plugins
PLUGINCONF      := /etc/nagios/plugins

all:

test:
	perl -MTest::Harness -e 'runtests @ARGV' t/*.t

install:
	install -d $(DESTDIR)$(PLUGINDIR)
	install -p $(PLUGIN_SCRIPT) $(DESTDIR)$(PLUGINDIR)/$(PLUGIN)
	install -d $(DESTDIR)$(PLUGINCONF)
	cp -p $(PLUGIN).cfg $(DESTDIR)$(PLUGINCONF)

dist:
	rm -rf $(PLUGIN)-$(PLUGIN_VERSION)
	install -d $(PLUGIN)-$(PLUGIN_VERSION)
	install -p $(PLUGIN_SCRIPT) $(PLUGIN)-$(PLUGIN_VERSION)/$(PLUGIN)
	cp -a check_raid.cfg t $(PLUGIN)-$(PLUGIN_VERSION)
	tar --exclude-vcs -czf $(PLUGIN)-$(PLUGIN_VERSION).tar.gz $(PLUGIN)-$(PLUGIN_VERSION)
	rm -rf $(PLUGIN)-$(PLUGIN_VERSION)
	md5sum -b $(PLUGIN)-$(PLUGIN_VERSION).tar.gz > $(PLUGIN)-$(PLUGIN_VERSION).tar.gz.md5
	chmod 644 $(PLUGIN)-$(PLUGIN_VERSION).tar.gz $(PLUGIN)-$(PLUGIN_VERSION).tar.gz.md5
