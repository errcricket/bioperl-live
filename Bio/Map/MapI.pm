# $Id$
#
# BioPerl module for Bio::Map::MapI
#
# Cared for by Sendu Bala <bix@sendu.me.uk>
#
# Copyright Jason Stajich
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::Map::MapI - Interface for describing Map objects in bioperl 

=head1 SYNOPSIS

    # get a MapI somehowe
    my $name   = $map->name();     # string
    my $length = $map->length();   # integer
    my $species= $map->species;    # Bio::Species
    my $type   = $map->type();     # genetic/sts/rh/

=head1 DESCRIPTION

This object describes the basic functionality of a Map in bioperl.
Maps are anything from Genetic Map to Sequence Map to and Assembly Map
to Restriction Enzyme to FPC.

=head1 FEEDBACK

=head2 Mailing Lists

User feedback is an integral part of the evolution of this and other
Bioperl modules. Send your comments and suggestions preferably to
the Bioperl mailing list.  Your participation is much appreciated.

  bioperl-l@bioperl.org                  - General discussion
  http://bioperl.org/wiki/Mailing_lists  - About the mailing lists

=head2 Reporting Bugs

Report bugs to the Bioperl bug tracking system to help us keep track
of the bugs and their resolution. Bug reports can be submitted via the
web:

  http://bugzilla.open-bio.org/

=head1 AUTHOR - Jason Stajich

Email jason@bioperl.org

=head1 CONTRIBUTORS

Lincoln Stein, lstein@cshl.org
Heikki Lehvaslaiho, heikki-at-bioperl-dot-org
Sendu Bala, bix@sendu.me.uk

=head1 APPENDIX

The rest of the documentation details each of the object methods.
Internal methods are usually preceded with a _

=cut

# Let the code begin...

package Bio::Map::MapI;
use vars qw(@ISA);
use strict;
use Bio::Map::EntityI;
use Bio::Map::PositionHandler;

@ISA = qw(Bio::Map::EntityI);

=head2 EntityI methods

 These are fundamental to coordination of Maps and other entities, so are
 implemented at the interface level

=cut

=head2 get_position_handler

 Title   : get_position_handler
 Usage   : my $position_handler = $entity->get_position_handler();
 Function: Gets a PositionHandlerI that $entity is registered with.
 Returns : Bio::Map::PositionHandlerI object
 Args    : none

=cut

sub get_position_handler {
    my $self = shift;
    unless (defined $self->{_eh}) {
        my $ph = Bio::Map::PositionHandler->new($self);
        $self->{_eh} = $ph;
        $ph->register;
    }
    return $self->{_eh};
}

=head2 PositionHandlerI-related methods

 These are fundamental to coordination of Maps and other entities, so are
 implemented at the interface level

=cut

=head2 get_positions

 Title   : get_positions
 Usage   : my @positions = $mappable->get_positions();
 Function: Get all the Positions on this Map (sorted).
 Returns : Array of L<Bio::Map::PositionI> objects
 Args    : none for all, OR
           L<Bio::Map::MappableI> object for positions of the given Mappable

=cut

sub get_positions {
    my ($self, $mappable) = @_;
	my @positions = $self->get_position_handler->get_positions($mappable);
	return sort { $a->sortable <=> $b->sortable } @positions;
}

=head2 each_position

 Title   : each_position
 Function: Synonym of the get_positions() method.
 Status  : deprecated, will be removed in next version

=cut

*each_position = \&get_positions;

=head2 purge_positions

 Title   : purge_positions
 Usage   : $map->purge_position();
 Function: Remove all positions from this map. Notifies the positions they are
           no longer on this map.
 Returns : n/a
 Args    : none to remove all positions, OR
           L<Bio::Map::PositionI> object to remove just that Position, OR
		   L<Bio::Map::MappableI> object to remove only those positions of the
           given mappable

=cut

sub purge_positions {
    my ($self, $thing) = @_;
    $self->get_position_handler->purge_positions($thing);
}

=head2 get_elements

 Title   : get_elements
 Usage   : my @elements = $map->get_elements;
 Function: Retrieves all the elements on a map (unordered unless all elements
           have just 1 position on the map, in which case sorted)
 Returns : Array of Map elements (L<Bio::Map::MappableI>)
 Args    : none

=cut

sub get_elements {
    my $self = shift;
    return $self->get_position_handler->get_other_entities;
}

=head2 each_element

 Title   : each_element
 Function: Synonym of the get_elements() method.
 Status  : deprecated, will be removed in the next version

=cut

=head2 MapI-specific methods

=cut

=head2 species

 Title   : species
 Usage   : my $species = $map->species;
 Function: Get/Set Species for a map
 Returns : L<Bio::Species> object
 Args    : (optional) Bio::Species

=cut

sub species{
    my $self = shift;
    $self->throw_not_implemented();
}

=head2 units

 Title   : units
 Usage   : $map->units('cM');
 Function: Get/Set units for a map
 Returns : units for a map
 Args    : units for a map (string)

=cut

sub units{
    my $self = shift;
    $self->throw_not_implemented();
}

=head2 type

 Title   : type
 Usage   : my $type = $map->type
 Function: Get/Set Map type
 Returns : String coding map type
 Args    : (optional) string

=cut

sub type {
    my $self = shift;
    $self->throw_not_implemented();
}

=head2 name

 Title   : name
 Usage   : my $name = $map->name
 Function: Get/Set Map name
 Returns : Map name
 Args    : (optional) string

=cut

sub name {
    my $self = shift;
    $self->throw_not_implemented();
}

=head2 length

 Title   : length
 Usage   : my $length = $map->length();
 Function: Retrieves the length of the map. 
           It is possible for the length to be unknown for maps such as
           Restriction Enzyme, will return 0 in that case
 Returns : integer representing length of map in current units
           will return undef if length is not calculateable
 Args    : none

=cut

sub length {
    my $self = shift;
    $self->throw_not_implemented();
}

=head2 unique_id

 Title   : unique_id
 Usage   : my $id = $map->unique_id;
 Function: Get/Set the unique ID for this map
 Returns : a unique identifier
 Args    : [optional] new identifier to set 

=cut

sub unique_id {
    my $self = shift;
    $self->throw_not_implemented();
}

1;
