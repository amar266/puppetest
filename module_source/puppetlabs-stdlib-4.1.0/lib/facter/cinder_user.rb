require 'facter'
Facter.add(:cinder_user) do
  confine :kernel=> :linux
    setcode do
         %x{grep cinder /etc/passwd |cut -f1 -d:}.chomp

end
end

